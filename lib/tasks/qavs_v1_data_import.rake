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
    end
  end

  task how_did_you_hear_about_award_update: :environment do
    FormAnswer.all.each do |fa|
      fa.document["how_did_you_hear_about_award"] = case fa.document["how_did_you_hear_about_award"]
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
      end
      fa.save!
    end
  end
end
