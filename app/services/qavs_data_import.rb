require 'net/http'

class QavsDataImport
  attr_reader :path

  def initialize(path)
    @path = path

    @logs = {
      warn: [],
      error: []
    }
  end

  def run!
    ay = AwardYear.where(year: 2022).first

    log("Start import")

    CSV.foreach(Rails.root.join(path), headers: true) do |row|
      oid = row["oid"]

      log("Importing #{oid}")

      if FormAnswer.find_by_oid(oid)
        log("Skipping #{oid}, already imported")
        next
      end

      if row["nomination_award_year"].blank?
        log("Skipping #{oid}, No AY")
        next
      end

      if row["nomination_award_year"] != "2022"
        log("Skipping #{oid}, Incorrect AY")
        next
      end

      if row["status"] == "draft"
        log("Skipping #{oid}, is a draft")
        next
      end

      FormAnswer.transaction do
        # <CREATING USER>
        nominator_email = row["nominator_email"]

        next unless nominator_email.present?

        unless (u = User.find_by_email(nominator_email)).present?
          u = User.new
          u.email = nominator_email
          u.first_name, u.last_name = split_name(row["nominator_name"])
          u.password = SecureRandom.hex(20)
          u.confirmed_at = Time.zone.now
          u.agreed_with_privacy_policy = "1"
          u.save!
        end

        # </CREATING USER>

        # <CREATING NOMINATION>
        fa = ay.form_answers.build
        fa.user = u
        fa.account = u.account
        fa.oid = oid

        fa.state = map_state(row["status"])
        document = {}

        row.each do |v1_name, value|
          v2_name = field_map(v1_name)

          # only import document fields in this cycle

          next if !v2_name.start_with?("doc.")

          v2_name.gsub!(/\Adoc\./, '')


          case v2_name
          when "nominee_activity", "secondary_activity"
            # Setting activity
            # If we don't have the value or it does not match
            # We set "OTH" as in Other activity
            if value.blank?
              document[v2_name] = "OTH"
            else
              activity = NomineeActivityHelper.lookup_key_for_label(value)
              if activity
                document[v2_name] = activity
              else
                document[v2_name] = "OTH"
              end
            end
          when "nominee_ceremonial_county"
            # Setting ceremonial county
            # If we don't have the value or it does not match
            # We set first CC as CC
            county = CeremonialCounty.where("LOWER(name) = LOWER(?)", value).first
            unless county
              log("#{oid}: No county found for `#{value}`, assigning to the first one", :warn)
              county = CeremonialCounty.first
            end

            document[v2_name] = county.id
          when "beneficiaries"
            # truncating
            if value && value.split(" ").count > 30
              log("Beneficiaries too long for `#{oid}`, truncating", :warn)
              value = value.split(" ")[0..29].join(" ")
            end

            document[v2_name] = prepare_value(value)
          else
            document[v2_name] = prepare_value(value)
          end
        end

        document["entry_confirmation"] = "on"
        document["understood_privacy_notice"] = "1"

        fa.document = document
        fa.sub_group = row["category_name"].presence && row["category_name"].gsub("Category ", "sub_group_")
        fa.state = "application_in_progress"
        fa.created_at = row["created_at"]
        fa.updated_at = row["updated_at"]
        fa.save!

        # Eligibility
        eligibility = fa.build_form_basic_eligibility
        eligibility.account = u.account
        eligibility.save_as_eligible!
        # / Eligibility

        # Letters of support

        document["supporter_letters_list"] = []

        opts = {
          document: document,
          row: row,
          user: u,
          form_answer: fa
        }

        add_support_letter(opts.merge(number: :first))
        add_support_letter(opts.merge(number: :second))

        # /Letters of support

        document["manually_upload"] = "yes"

        fa.document = document
        fa.state = "submitted"
        fa.submitted_at = Time.zone.now
        fa.save!
      end
    end

    log("Finished")

    log("Stats:")

    @logs.each do |k, v|
      v.each do |err|
        Rails.logger.send(k, err)
      end
    end

    nil
  end

  private

  def prepare_value(value)
    (value && value.strip.presence || "---").gsub(/[\u200B-\u200D\uFEFF]/, '')
  end

  def add_support_letter(options)
    number = options[:number]
    document = options[:document]
    row = options[:row]
    u = options[:user]
    fa = options[:form_answer]

    support_letter = fa.support_letters.new
    support_letter.user_id = u.id
    support_letter.manual = true
    support_letter.first_name = split_name(row["#{number}_letter_of_support_name_of_supporter"])[0]
    support_letter.last_name = split_name(row["#{number}_letter_of_support_name_of_supporter"])[1]
    support_letter.relationship_to_nominee = row["#{number}_letter_of_support_relationship_to_group"]

    uri = row["#{number}_letter_of_support_file_uri"]

    download_file(uri)
    tmp_file_path = Rails.root.join("tmp/#{original_file_name(uri)}")
    file = File.open(tmp_file_path)

    attachment = SupportLetterAttachment.new(attachment: file)
    attachment.user = u
    attachment.form_answer = fa
    attachment.original_filename = original_file_name(row["#{number}_letter_of_support_file_uri"])
    support_letter.support_letter_attachment = attachment
    support_letter.save!

    File.delete(tmp_file_path)

    new_letter = {
      support_letter_id: support_letter.id,
      first_name: support_letter.first_name,
      last_name: support_letter.last_name,
      relationship_to_nominee: support_letter.relationship_to_nominee,
      letter_of_support: support_letter.support_letter_attachment.id
    }

    document["supporter_letters_list"] << new_letter
  end

  def download_file(uri)
    qavs_url = "https://apply.qavs.dcms.gov.uk"

    full_url = URI(qavs_url + uri)
    req = Net::HTTP::Get.new(full_url)
    req["X-qavs-public-files-api-key"] = ENV["QAVS_FILES_TOKEN"]

    resp = Net::HTTP.start(full_url.hostname, full_url.port, use_ssl: true) do |http|
      http.request(req)
    end

    open(Rails.root.join("tmp/#{original_file_name(uri)}"), "wb") do |file|
      file.write(resp.body)
    end
  end

  def original_file_name(uri)
    uri.split("/").last
  end

  def log(str, kind = :info)
    case kind
    when :error
      @logs[:error] += [str]
    when :warn
      @logs[:warn] += [str]
    end

    Rails.logger.send(kind, str)
  end

  # Splits name into First name and last name
  # Where it's needed
  def split_name(str)
    splat = str.split(" ")

    first_name = splat[0].presence || "-"
    last_name = splat[1..-1].join(" ").presence || "-"

    [first_name, last_name]
  end

  def map_state(status)
    {
      "new" => "submitted",
      "awarded" => "awarded"
    }
  end

  def field_map(field)
    {
      "oid" => "oid",
      "nomination_award_year" => "skip",
      "name" => "skip",
      "status" => "state",
      "created_at" => "created_at",
      "updated_at" => "updated_at",

      "group_name" => "doc.nominee_name",
      "category_name" => "sub_group",
      "main_activity_area" => "doc.nominee_activity",
      "secondary_activity_area" => "doc.secondary_activity",

      "group_address_name" => "doc.nominee_address_building",
      "group_address_street" => "doc.nominee_address_street",
      "group_address_village_or_town" => "doc.nominee_address_city",
      "group_address_county" => "doc.nominee_address_county",
      "group_address_postcode" => "doc.nominee_address_postcode",
      "group_address_london_borough" => "skip",
      "group_address_lieutenancy_county" => "doc.nominee_ceremonial_county",

      "ceremonial_county_name" => "doc.nominee_ceremonial_county",
      "group_tel" => "doc.nominee_phone",
      "group_website" => "doc.nominee_website",
      "group_social_media" => "doc.social_media",

      "group_leader_name" => "doc.nominee_leader_name",
      "group_leader_position" => "doc.nominee_leader_position",
      "group_leader_address_name" => "doc.nominee_leader_address_building",
      "group_leader_address_street" => "doc.nominee_leader_address_street",
      "group_leader_address_village_or_town" => "doc.nominee_leader_address_city",
      "group_leader_address_county" => "doc.nominee_leader_address_county",
      "group_leader_address_postcode" => "doc.nominee_leader_address_postcode",
      "group_leader_address_london_borough" => "skip",
      "group_leader_email" => "doc.nominee_leader_email",
      "group_leader_telephone" => "doc.nominee_leader_telephone",

      "recommendation_details_group_activities" => "doc.group_activities",
      "recommendation_details_who_benefits" => "doc.beneficiaries",
      "recommendation_details_what_are_the_benefits" => "doc.benefits",
      "recommendation_details_about_the_groups_volunteers" => "doc.volunteers",

      "recommendation_details_how_has_the_group_achieved_excellence" => "doc.",
      "demographic_info_how_did_you_hear" => "doc.how_did_you_hear_about_award",

      # LOS
      "first_letter_of_support_name_of_supporter" => "skip",
      "first_letter_of_support_relationship_to_group" => "skip",
      "first_letter_of_support_file_uri" => "skip",
      "second_letter_of_support_name_of_supporter" => "skip",
      "second_letter_of_support_relationship_to_group" => "skip",
      "second_letter_of_support_file_uri" => "skip",

      "nominator_oid" => "skip",
      "nominator_name" => "doc.nominator_name",
      "nominator_address_name" => "doc.nominator_address_building",
      "nominator_address_street" => "doc.nominator_address_street",
      "nominator_address_village_or_town" => "doc.nominator_address_city",
      "nominator_address_county" => "doc.nominator_address_county",
      "nominator_address_postcode" => "doc.nominator_address_postcode",
      "nominator_address_london_borough" => "skip",
      "nominator_tel" => "doc.nominator_telephone",
      "nominator_mobile" => "doc.nominator_mobile",
      "nominator_email" => "doc.nominator_email",
      "nominator_is_not_volunteer" => "doc.not_volunteer",
      "nominator_group_nominator_not_involved" => "skip",
      "nominator_agrees_to_privacy" => "doc.understood_privacy_notice",
      "nominator_has_permission_for_letters_of_support" => "doc.group_leader_aware",

      # Eligibility
      "group_has_at_least_three_people" => "skip",
      "group_are_majority_volunteers" => "skip",
      "group_based_on_uk" => "skip",
      "group_national_organisation" => "skip",
      "group_affiliated_to" => "skip",
      "group_benefits_animals_only" => "skip",
      "group_years_operating" => "skip",
      "demographic_info_how_did_you_hear_other" => "skip",
      "demographic_info_ethnic_origin" => "skip",
      "demographic_info_ethnic_origin_other" => "skip"
    }[field]
  end
end
