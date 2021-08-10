require 'csv'

namespace :ceremonial_counties do
  desc "Load Lieutenancy/CeremonialCounty"
  task load: :environment do
    path = "#{Rails.root}/db/fixtures/ceremonial_counties.csv"
    counties = []
    CSV.foreach(path, headers: true) do |row|
      h = row.to_hash
      name = h["name"]
      country = h["country"]
     counties << CeremonialCounty.new(name: name, country: country)
    end
    CeremonialCounty.import counties, on_duplicate_key_update: [:country]
  end
end
