require 'csv'

namespace :qavsv1 do
  task data_import: :environment do
    Rails.logger = Logger.new(STDOUT)

    QavsDataImport.new("tmp/nominations_production.csv").run!
  end
end
