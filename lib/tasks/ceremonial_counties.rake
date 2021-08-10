require 'csv'

namespace :ceremonial_counties do
  desc "Load Lieutenancy/CeremonialCounty"
  task load: :environment do
    path = "#{Rails.root}/db/fixtures/ceremonial_counties.csv"
    CSV.foreach(path, headers: true) do |row|
      CeremonialCounty.create! row.to_hash
    end
  end
end
