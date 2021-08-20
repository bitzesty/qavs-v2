require 'csv'

namespace :ceremonial_counties do
  desc "Load Lieutenancy/CeremonialCounty"
  task load: :environment do
    path = "#{Rails.root}/db/fixtures/ceremonial_counties.csv"
    counties = []
    CSV.foreach(path, headers: true) do |row|
      name = row[0]
      country = row[1]
      counties << CeremonialCounty.new(name: name, country: country)
    end
    results = CeremonialCounty.import counties, on_duplicate_key_update: {conflict_target: [:name], columns: [:country]}
    puts "inserted #{results.ids.count} records"
    if results.failed_instances.any?
      puts "failed records:"
      puts results.failed_instances.inspect
    end
  end
end
