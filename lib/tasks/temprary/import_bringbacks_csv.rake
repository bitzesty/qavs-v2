namespace :applications do
  desc "Import bringbacks CSV file (supports local files and Google Drive/Sheets URLs)"
  task :import_bringbacks, [:csv_path, :award_year, :auto_submit] => :environment do |t, args|
    csv_path = args[:csv_path] || ENV['CSV_PATH']

    unless csv_path.present?
      puts "ERROR: CSV path is required. Please provide it as an argument or CSV_PATH environment variable."
      puts "Usage: rake applications:import_bringbacks[path/to/file.csv]"
      puts "   or: CSV_PATH=path/to/file.csv rake applications:import_bringbacks"
      exit 1
    end

    award_year = args[:award_year] || ENV['AWARD_YEAR'] || 2026
    # Default to true unless explicitly set to 'false'
    auto_submit = if args[:auto_submit].present?
                    args[:auto_submit] != 'false'
                  elsif ENV['AUTO_SUBMIT'].present?
                    ENV['AUTO_SUBMIT'] != 'false'
                  else
                    true
                  end

    # If it's not a URL, use absolute path if relative
    unless csv_path.match?(/^https?:\/\//)
      unless csv_path.start_with?('/')
        csv_path = Rails.root.join(csv_path).to_s
      end
    end

    options = {}
    options[:award_year] = award_year.to_i if award_year.present?
    options[:auto_submit] = auto_submit

    puts "Importing bringbacks from: #{csv_path}"
    puts "Award Year: #{options[:award_year] || 'current'}"
    puts "Auto Submit: #{auto_submit}"
    puts ""

    result = ManualUpdaters::ImportBringbacksCsv.new(csv_path, options).run!

    puts ""
    puts "=== Import Summary ==="
    puts "Created: #{result[:created].count}"
    puts "Skipped: #{result[:skipped].count}"
    puts "Errors: #{result[:errors].count}"

    if result[:errors].any?
      puts ""
      puts "=== FAILURE LIST ==="
      result[:errors].each_with_index do |error, index|
        puts "Failure ##{index + 1}:"
        puts "  Row: #{error[:row]}"
        puts "  Email: #{error[:email] || 'N/A'}"
        puts "  Nominee: #{error[:nominee_name] || 'N/A'}" if error[:nominee_name]
        puts "  Error: #{error[:error]}"
        if error[:backtrace]
          puts "  Backtrace: #{error[:backtrace].first(3).join(' | ')}"
        end
        puts ""
      end
      puts "=== END OF FAILURE LIST ==="
      puts ""
      puts "Total Failures: #{result[:errors].count}"
    end

    if result[:created].any?
      puts ""
      puts "=== First 5 Created Applications ==="
      result[:created].first(5).each do |created|
        puts "Row #{created[:row]}: #{created[:nominee_name]} (ID: #{created[:form_answer_id]})"
      end
    end
  end
end
