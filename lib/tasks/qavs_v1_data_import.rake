require 'csv'

namespace :qavsv1 do
  task data_import: :environment do
    Rails.logger = Logger.new(STDOUT)

    QavsDataImport.new("tmp/nominations_production.csv").run!
  end

  task ll_import: :environment do
    Rails.logger = Logger.new(STDOUT)

    LieutenantsImport.new("tmp/lieutenants_production.csv").run!
  end

  task eligibility_update: :environment do
    Rails.logger = Logger.new(STDOUT)
    path = "tmp/nominations_production.csv"

    CSV.foreach(Rails.root.join(path), headers: true) do |row|
      oid = row["oid"]

      fa = FormAnswer.find_by_oid(oid)

      state = case row["status"]
      when "eligible"
        "admin_eligible"
      when "ineligible"
        "admin_not_eligible_group"
      when "withdrawn"
        "withdrawn"
      else
        raise "Status not found: #{row["status"]}"
      end

      Rails.logger.info("#{oid}, #{state}")

      fa.update_column(:state, state)

      if state == "admin_not_eligible_group"
        fa.update_column(:ineligible_reason_group, "no_specific_benefit")
      end
    end
  end

  task how_did_you_hear_about_award_update: :environment do
    Rails.logger = Logger.new(STDOUT)

    FormAnswer.find_each do |fa|
      Rails.logger.info("#{fa.id} #{fa.document["how_did_you_hear_about_award"]}")

      old_hdyh = fa.document["how_did_you_hear_about_award"]
      fa.document["how_did_you_hear_about_award"] = case old_hdyh
      when "National newspaper"
        [{ "type": "national_newspaper" }]
      when "Local newspaper"
        [{ "type": "local_newspaper" }]
      when "TV/radio"
        [{ "type": "tv_radio" }]
      when "Internet"
        [{ "type": "internet" }]
      when "Word of mouth"
        [{ "type": "word_of_mouth" }]
      when "Previous winner/entrant"
        [{ "type": "previous_winner" }]
      when "Voluntary organisation/charity"
        [{ "type": "charity" }]
      when "Local event"
        [{ "type": "event" }]
      when "Local library"
        [{ "type": "library" }]
      when "Local council"
        [{ "type": "council" }]
      when "Other"
        [{ "type": "other" }]
      else
        if old_hdyh.is_a?(Array) && old_hdyh.any?
          next
        elsif old_hdyh.blank?
          [{ "type": "other" }]
        end
      end
      Rails.logger.info(fa.document["how_did_you_hear_about_award"])

      fa.save!
    end
  end

  task volunteers_upgrade: :environment do
    Rails.logger = Logger.new(STDOUT)

    path = "tmp/nominations_production.csv"

    CSV.foreach(Rails.root.join(path), headers: true) do |row|
      oid = row["oid"]

      fa = FormAnswer.find_by_oid(oid)

      fa.document["volunteers"] = row["recommendation_details_how_has_the_group_achieved_excellence"]
      Rails.logger.info oid

      fa.save!
    end

    Rails.logger.info "Done"
  end
end
