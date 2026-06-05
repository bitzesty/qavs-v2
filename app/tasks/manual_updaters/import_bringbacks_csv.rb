#
# Import Bringbacks CSV
#
# Specific importer for the "Final_ KAVS Bringbacks 2026 - Bitzesty - Sheet1.csv" file
#
# Usage:
#   ::ManualUpdaters::ImportBringbacksCsv.new(csv_path, options).run!
#
# Options:
#   - award_year: AwardYear instance or year (integer). Defaults to 2026
#   - auto_submit: Boolean. If true, automatically submits applications. Default: false

require 'csv'
require 'uri'

module ManualUpdaters
  class ImportBringbacksCsv
    attr_reader :csv_path, :options, :logs

    def initialize(csv_path, options = {})
      @csv_path = csv_path
      @options = {
        award_year: 2026,
        auto_submit: true
      }.merge(options)
      @logs = {
        created: [],
        skipped: [],
        errors: []
      }
      @temp_csv_file = nil
    end

    def run!
      log("Starting CSV import from #{csv_path}")

      # Check if csv_path is a URL
      if url?(csv_path)
        log("Detected URL, downloading CSV file...")
        downloaded_path = download_csv_from_url(csv_path)
        unless downloaded_path
          log("ERROR: Could not download CSV from URL: #{csv_path}", :error)
          return logs
        end
        @temp_csv_file = downloaded_path
        actual_csv_path = downloaded_path
      else
        unless File.exist?(csv_path)
          log("ERROR: File not found: #{csv_path}", :error)
          return logs
        end
        actual_csv_path = csv_path
      end

      award_year = resolve_award_year
      unless award_year
        log("ERROR: Invalid award year", :error)
        cleanup_temp_file
        return logs
      end

      begin
        # Read the CSV content first to handle encoding issues
        csv_content = File.read(actual_csv_path, encoding: 'UTF-8')

        # Normalize line endings and handle BOM if present
        csv_content = csv_content.encode('UTF-8', 'UTF-8', invalid: :replace, undef: :replace)
        csv_content = csv_content.gsub(/\r\n/, "\n").gsub(/\r/, "\n")

        # Parse CSV with lenient options for Google Sheets exports
        # Track line number manually since CSV.parse doesn't provide it
        row_number = 1 # Start at 1 for header row, first data row will be 2
        CSV.parse(csv_content,
                  headers: true,
                  liberal_parsing: true,
                  quote_char: '"',
                  col_sep: ',',
                  encoding: 'UTF-8') do |row|
          row_number += 1
          process_row(row, award_year, row_number)
        end
      rescue CSV::MalformedCSVError => e
        log("CSV parsing error: #{e.message}", :error)
        log("Line number: #{e.lineno if e.respond_to?(:lineno)}", :error)
        log("This may be due to unquoted fields with newlines in the Google Sheet.", :error)
        log("Try ensuring all cells with line breaks are properly formatted in Google Sheets.", :error)
        raise e
      ensure
        cleanup_temp_file
      end

      log("Import completed")
      log("Created: #{logs[:created].count}")
      log("Skipped: #{logs[:skipped].count}")
      log("Errors: #{logs[:errors].count}")

      # Print detailed error list
      if logs[:errors].any?
        log("")
        log("=== FAILURE LIST ===", :error)
        logs[:errors].each_with_index do |error, index|
          log("Failure ##{index + 1}:", :error)
          log("  Row: #{error[:row]}", :error)
          log("  Email: #{error[:email] || 'N/A'}", :error)
          log("  Nominee: #{error[:nominee_name] || 'N/A'}", :error) if error[:nominee_name]
          log("  Error: #{error[:error]}", :error)
          if error[:backtrace]
            log("  Backtrace: #{error[:backtrace].first(3).join(' | ')}", :error)
          end
          log("", :error)
        end
        log("=== END OF FAILURE LIST ===", :error)
      end

      logs
    end

    private

    def url?(path)
      path.to_s.match?(/^https?:\/\//)
    end

    def download_csv_from_url(url)
      require 'net/http'
      require 'uri'
      require 'open-uri'
      require 'fileutils'

      begin
        original_url = url.strip
        uri = URI.parse(original_url)

        # Handle Google Sheets URLs - convert to CSV export format
        allowed_google_hosts = ['docs.google.com']
        if allowed_google_hosts.include?(uri.host) && uri.path&.include?('/spreadsheets/')
          sheet_id = extract_google_sheet_id(original_url)
          if sheet_id
            # Extract gid (sheet tab ID) if present
            gid = extract_gid_from_url(original_url)

            # Build CSV export URL
            export_url = "https://docs.google.com/spreadsheets/d/#{sheet_id}/export?format=csv"
            export_url += "&gid=#{gid}" if gid
            uri = URI.parse(export_url)
            log("Converting Google Sheets URL to CSV export: #{export_url}")
          end
        end

        # Create temp file
        tmp_file_path = Rails.root.join("tmp", "import_csv_#{SecureRandom.hex(8)}.csv")

        # Ensure tmp directory exists
        FileUtils.mkdir_p(File.dirname(tmp_file_path))

        # Download the CSV file
        log("Downloading CSV from #{uri.to_s}...")

        begin
          # Use URI.open explicitly to avoid conflict with Kernel#open
          require 'open-uri'

          # Use URI(..).open to avoid calling Kernel.open with a non-constant value
          response = URI(uri.to_s).open(
               read_timeout: 60,
               'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36')

          # Check if we got HTML instead of CSV (common when file is not public)
          content = response.read

          # Check if response is HTML (Google error page)
          if content.start_with?('<!DOCTYPE') || content.start_with?('<html') || content.include?('Sign in')
            log("ERROR: Received HTML instead of CSV. The Google Sheet may not be publicly accessible.", :error)
            log("Please ensure the sheet is shared with 'Anyone with the link can view'", :error)
            log("Response preview: #{content[0..200]}", :error)
            File.delete(tmp_file_path) if File.exist?(tmp_file_path)
            return nil
          end

          File.open(tmp_file_path, 'wb') do |local_file|
            local_file.write(content)
          end
        rescue OpenURI::HTTPError => e
          log("HTTP Error downloading CSV: #{e.message}", :error)
          if e.io.respond_to?(:status)
            log("Status: #{e.io.status.join(' ')}", :error)
          end
          log("The Google Sheet may require authentication or may not be publicly accessible.", :error)
          File.delete(tmp_file_path) if File.exist?(tmp_file_path)
          return nil
        end

        if File.exist?(tmp_file_path) && File.size(tmp_file_path) > 0
          # Verify it's actually CSV (not HTML error page)
          first_line = File.read(tmp_file_path, 100)
          if first_line.start_with?('<!DOCTYPE') || first_line.start_with?('<html')
            log("ERROR: Downloaded file appears to be HTML, not CSV. The sheet may not be publicly accessible.", :error)
            File.delete(tmp_file_path)
            return nil
          end

          log("Downloaded CSV file (#{File.size(tmp_file_path)} bytes) to #{tmp_file_path}")
          tmp_file_path.to_s
        else
          log("Downloaded CSV file appears to be empty or missing", :error)
          File.delete(tmp_file_path) if File.exist?(tmp_file_path)
          nil
        end
      rescue => e
        log("Error downloading CSV from #{url}: #{e.message}", :error)
        log("Error class: #{e.class}", :error)
        log("Backtrace: #{e.backtrace.first(5).join("\n")}", :error)
        File.delete(tmp_file_path) if defined?(tmp_file_path) && tmp_file_path && File.exist?(tmp_file_path)
        nil
      end
    end

    def extract_google_sheet_id(url)
      # Match patterns like:
      # /spreadsheets/d/{SHEET_ID}/edit
      # /spreadsheets/d/{SHEET_ID}/export
      match = url.match(/\/spreadsheets\/d\/([a-zA-Z0-9_-]+)/)
      match ? match[1] : nil
    end

    def extract_gid_from_url(url)
      # Extract gid parameter if present (for specific sheet tabs)
      uri = URI.parse(url)
      params = URI.decode_www_form(uri.query || '').to_h
      params['gid']
    end

    def cleanup_temp_file
      if @temp_csv_file && File.exist?(@temp_csv_file)
        File.delete(@temp_csv_file)
        log("Cleaned up temporary CSV file: #{@temp_csv_file}")
      end
    end

    def process_row(row, award_year, row_number = nil)
      email = row["Nominator email address (account to assign nomination to)"]

      unless email.present?
        log("Row #{row_number || 'unknown'}: Skipping - no email found", :error)

        # Try to get nominee name from row if available
        nominee_name = nil
        begin
          nominee_name = row["A1.1 Name of group/organisation/individual"] || row["A1.1 Name of group/organisation/individual "] if row
        rescue
          # Ignore errors when trying to get nominee name
        end

        logs[:errors] << {
          row: row_number || 0,
          email: 'N/A',
          nominee_name: nominee_name,
          error: "No email found"
        }
        return
      end

      email = email.strip.downcase

      # Find or create user
      user = User.find_by_email(email)
      if user
        log("Row #{row_number || 'unknown'}: User already exists: #{email}, will create form_answer for existing user")
      else
        user = create_user(row, email)
      end

      FormAnswer.transaction do
        form_answer = create_form_answer(row, user, award_year)

        if form_answer
          create_eligibility(form_answer, user)
          create_support_letters(row, form_answer, user)

          if options[:auto_submit]
            submit_application(form_answer)
          end

          log("Row #{row_number || 'unknown'}: Created application #{form_answer.id} for #{email}")
          logs[:created] << {
            row: row_number || 0,
            email: email,
            form_answer_id: form_answer.id,
            nominee_name: form_answer.company_or_nominee_name
          }
        end
      end
    rescue => e
      log("Row #{row_number || 'unknown'}: Error - #{e.message}", :error)
      log("Row #{row_number || 'unknown'}: Backtrace - #{e.backtrace.first(5).join("\n")}", :error)

      # Try to get nominee name from row if available
      nominee_name = nil
      begin
        nominee_name = row["A1.1 Name of group/organisation/individual"] || row["A1.1 Name of group/organisation/individual "] if row
      rescue
        # Ignore errors when trying to get nominee name
      end

      logs[:errors] << {
        row: row_number || 0,
        email: email || 'N/A',
        nominee_name: nominee_name,
        error: e.message,
        backtrace: e.backtrace
      }
    end

    def create_user(row, email)
      # Get nominator name from D1.2 Name
      nominator_name = row["D1.2 Name "].to_s.strip
      first_name, last_name = split_name(nominator_name)

      # Fallback to title + name if available
      if first_name.blank? || last_name.blank?
        title = row["D1.1.Title:"].to_s.strip
        full_name = [title, nominator_name].reject(&:blank?).join(" ")
        first_name, last_name = split_name(full_name)
      end

      first_name = "Imported" if first_name.blank?
      last_name = "User" if last_name.blank?

      user = User.new
      user.email = email
      user.first_name = first_name
      user.last_name = last_name
      user.password = SecureRandom.hex(20)
      user.password_confirmation = user.password
      user.confirmed_at = Time.zone.now
      user.agreed_with_privacy_policy = "1"
      user.save!

      log("Created user: #{email} (#{first_name} #{last_name})")
      user
    end

    def create_form_answer(row, user, award_year)
      form_answer = award_year.form_answers.build
      form_answer.user = user
      form_answer.account = user.account
      form_answer.state = "application_in_progress"

      document = build_document(row)
      form_answer.document = document

      # Set ceremonial county from Lieutenancy
      if row["Lieutenancy"].present?
        county = CeremonialCounty.where("LOWER(name) = LOWER(?)", row["Lieutenancy"].strip).first
        if county
          form_answer.ceremonial_county = county
        else
          log("Warning: Ceremonial county not found: #{row['Lieutenancy']}", :warn)
        end
      end

      form_answer.save!
      form_answer
    end

    def build_document(row)
      document = {}

      # Nominee/Group information
      document['nominee_name'] = prepare_value(row["A1.1. Name of group"])
      document['nominee_established_date'] = prepare_value(row["A1.2. When was the group established?"])
      document['nominee_activity'] = map_activity(row["A1.3. Please select the group's main area of activity"])
      document['secondary_activity'] = map_activity(row["A1.4. Please select the group's secondary area of activity"])

      # Nominee address
      document['nominee_address_building'] = prepare_value(row["A1.5 Building"])
      document['nominee_address_street'] = prepare_value(row["A1.5. Street"])
      document['nominee_address_city'] = prepare_value(row["A1.5. Town or city"])
      document['nominee_address_county'] = prepare_value(row["A1.5. County"])
      document['nominee_address_postcode'] = prepare_value(row["A1.5. Postcode"])

      # Nominee contact
      document['nominee_phone'] = prepare_value(row["A1.6. Telephone number"])
      document['nominee_website'] = prepare_value(row["A1.7. Website"])
      document['social_media'] = prepare_value(row["A1.8. Social media"])

      # Nominee leader - handle tab character in header
      leader_name_key = row.headers.find { |h| h.to_s.include?("A2.1") && h.to_s.include?("Name of the group leader") }
      document['nominee_leader_name'] = prepare_value(row[leader_name_key]) if leader_name_key
      document['nominee_leader_position'] = prepare_value(row["A2.2. Position held in the group"])
      document['nominee_leader_address_building'] = prepare_value(row["A2.3 Building"])
      document['nominee_leader_address_street'] = prepare_value(row["A2.3 Street"])
      document['nominee_leader_address_city'] = prepare_value(row["A2.3 Town or city"])
      document['nominee_leader_address_county'] = prepare_value(row["A2.3 County"])
      document['nominee_leader_address_postcode'] = prepare_value(row["A2.3 Postcode"])
      document['nominee_leader_email'] = prepare_value(row["A2.4. Email"])
      document['nominee_leader_telephone'] = prepare_value(row["A2.5. Telephone"])

      # Recommendation details
      document['group_activities'] = prepare_value(row["B1. Please summarise the activities of the group"])
      document['beneficiaries'] = prepare_value(row["B2. Who are the beneficiaries (the people it helps) and where do they live?"])
      document['benefits'] = prepare_value(row["B3. What are the benefits of the group's work?"])
      document['volunteers'] = prepare_value(row["B4. This Award is specifically for groups that rely on significant and committed work by volunteers. Please explain what the volunteers do and what makes this particular group of volunteers so impressive?"])

      # How did you hear
      how_did_you_hear = prepare_value(row["B5. How did you hear about the Award this year?"])
      document['how_did_you_hear_about_award'] = map_how_did_you_hear(how_did_you_hear)

      # Nominator information
      nominator_title = prepare_value(row["D1.1.Title:"])
      nominator_name = prepare_value(row["D1.2 Name "])
      document['nominator_name'] = [nominator_title, nominator_name].reject(&:blank?).join(" ")
      document['nominator_address_building'] = prepare_value(row["D1.3 Building"])
      document['nominator_address_street'] = prepare_value(row["D1.3 Street"])
      document['nominator_address_city'] = prepare_value(row["D1.3 Town or city"])
      document['nominator_address_county'] = prepare_value(row["D1.3 County"])
      document['nominator_address_postcode'] = prepare_value(row["D1.3 Postcode"])
      # Handle the multiline header for telephone
      telephone_key = row.headers.find { |h| h.to_s.include?("D1.4") && h.to_s.include?("Telephone") }
      document['nominator_telephone'] = prepare_value(row[telephone_key]) if telephone_key
      document['nominator_mobile'] = prepare_value(row["D1.5. Mobile (optional)"])
      document['nominator_email'] = prepare_value(row["D1.6. Email address"])

      # Support letters will be added after form_answer is saved
      document['supporter_letters_list'] = []

      # Set default required fields
      document['entry_confirmation'] = 'on'
      document['understood_privacy_notice'] = '1'

      # Set D2 (not_volunteer) and D4 (group_leader_aware) to ticked by default if not in CSV
      document['not_volunteer'] = '1' unless document.key?('not_volunteer')
      document['group_leader_aware'] = '1' unless document.key?('group_leader_aware')

      # Set support letter checkboxes to ticked by default if not in CSV
      document['independent_individual'] = '1' unless document.key?('independent_individual')
      document['not_nominator'] = '1' unless document.key?('not_nominator')

      document
    end

    def create_support_letters(row, form_answer, user)
      supporter_letters_list = []

      # First support letter - find columns flexibly
      first_name_key = row.headers.find { |h| h.to_s.include?("C1.1") && h.to_s.include?("First name") }
      first_surname_key = row.headers.find { |h| h.to_s.include?("C1.1") && h.to_s.include?("Surname") }
      first_relationship_key = row.headers.find { |h| h.to_s.include?("C 1.2") || h.to_s.include?("C1.2") }
      first_url_key = row.headers.find { |h| h.to_s.include?("C 1.3") || h.to_s.include?("C1.3") }

      first_name = prepare_value(row[first_name_key]) if first_name_key
      first_surname = prepare_value(row[first_surname_key]) if first_surname_key
      first_relationship = prepare_value(row[first_relationship_key]) if first_relationship_key
      first_url = prepare_value(row[first_url_key]) if first_url_key

      # Create support letter if we have name and relationship
      # If URL is provided and valid, download and attach file
      if first_name.present? && first_surname.present? && first_relationship.present?
        if first_url.present? && first_url.match?(/^https?:\/\//)
          log("Creating first support letter for #{first_name} #{first_surname} from URL: #{first_url}")
          support_letter = add_support_letter(
            form_answer: form_answer,
            user: user,
            first_name: first_name,
            last_name: first_surname,
            relationship: first_relationship,
            url: first_url
          )
          supporter_letters_list << support_letter if support_letter
        else
          # Create support letter without attachment if we have name and relationship
          log("Creating first support letter for #{first_name} #{first_surname} without attachment (URL was filename: #{first_url})")
          support_letter = create_support_letter_without_attachment(
            form_answer: form_answer,
            user: user,
            first_name: first_name,
            last_name: first_surname,
            relationship: first_relationship
          )
          supporter_letters_list << support_letter if support_letter
        end
      end

      # Second support letter - find columns flexibly
      second_name_key = row.headers.find { |h| h.to_s.include?("C2.1") && h.to_s.include?("First name") }
      second_surname_key = row.headers.find { |h| h.to_s.include?("C2.1") && h.to_s.include?("Surname") }
      second_relationship_key = row.headers.find { |h| h.to_s.include?("C 2.2") || h.to_s.include?("C2.2") }
      second_url_key = row.headers.find { |h| h.to_s.include?("C 2.3") || h.to_s.include?("C2.3") }

      second_name = prepare_value(row[second_name_key]) if second_name_key
      second_surname = prepare_value(row[second_surname_key]) if second_surname_key
      second_relationship = prepare_value(row[second_relationship_key]) if second_relationship_key
      second_url = prepare_value(row[second_url_key]) if second_url_key

      # Create support letter if we have name and relationship
      # If URL is provided and valid, download and attach file
      if second_name.present? && second_surname.present? && second_relationship.present?
        if second_url.present? && second_url.match?(/^https?:\/\//)
          log("Creating second support letter for #{second_name} #{second_surname} from URL: #{second_url}")
          support_letter = add_support_letter(
            form_answer: form_answer,
            user: user,
            first_name: second_name,
            last_name: second_surname,
            relationship: second_relationship,
            url: second_url
          )
          supporter_letters_list << support_letter if support_letter
        else
          # Create support letter without attachment if we have name and relationship
          log("Creating second support letter for #{second_name} #{second_surname} without attachment (URL was filename: #{second_url})")
          support_letter = create_support_letter_without_attachment(
            form_answer: form_answer,
            user: user,
            first_name: second_name,
            last_name: second_surname,
            relationship: second_relationship
          )
          supporter_letters_list << support_letter if support_letter
        end
      end

      # Update document with support letters
      if supporter_letters_list.any?
        document = form_answer.document
        document['supporter_letters_list'] = supporter_letters_list
        form_answer.document = document
        form_answer.save!
        log("Added #{supporter_letters_list.count} support letter(s) to form_answer #{form_answer.id}")
      end
    end

    def create_support_letter_without_attachment(form_answer:, user:, first_name:, last_name:, relationship:)
      # Since SupportLetter requires an attachment when manual=true, create a placeholder text file
      begin
        # Create a placeholder text file with generic, non-PII content and filename
        placeholder_content = "Support letter placeholder.\n\n[Original letter file was not available for import.]"
        random_suffix = SecureRandom.hex(8)
        tmp_file_path = Rails.root.join("tmp", "support_letter_placeholder_#{random_suffix}.txt")
        FileUtils.mkdir_p(File.dirname(tmp_file_path))

        File.open(tmp_file_path, 'w') do |f|
          f.write(placeholder_content)
        end

        file = File.open(tmp_file_path)

        # Create attachment with placeholder file
        attachment = SupportLetterAttachment.new(attachment: file)
        attachment.user = user
        attachment.form_answer = form_answer
        attachment.original_filename = "support_letter_placeholder_#{random_suffix}.txt"
        attachment.save!

        # Create support letter
        support_letter = form_answer.support_letters.new
        support_letter.user = user
        support_letter.manual = true
        support_letter.first_name = first_name
        support_letter.last_name = last_name
        support_letter.relationship_to_nominee = relationship
        support_letter.support_letter_attachment = attachment
        support_letter.save!

        # Clean up temp file
        File.delete(tmp_file_path) if File.exist?(tmp_file_path)

        # Return hash for document
        {
          support_letter_id: support_letter.id,
          first_name: support_letter.first_name,
          last_name: support_letter.last_name,
          relationship_to_nominee: support_letter.relationship_to_nominee,
          letter_of_support: support_letter.support_letter_attachment.id
        }
      rescue => e
        log("Error creating support letter with placeholder attachment: #{e.message}", :error)
        File.delete(tmp_file_path) if defined?(tmp_file_path) && tmp_file_path && File.exist?(tmp_file_path)
        nil
      end
    end

    def add_support_letter(form_answer:, user:, first_name:, last_name:, relationship:, url:)
      begin
        # Download the file
        tmp_file_path = download_file_from_url(url)

        unless tmp_file_path && File.exist?(tmp_file_path)
          log("Warning: Could not download file from URL: #{url}", :warn)
          return nil
        end

        file = File.open(tmp_file_path)

        # Extract filename from the downloaded file path (which now has the correct extension)
        filename = File.basename(tmp_file_path)
        # If filename doesn't have an extension, try to get it from URL
        unless filename.include?('.')
          filename = extract_filename_from_url(url)
        end

        # Create attachment
        attachment = SupportLetterAttachment.new(attachment: file)
        attachment.user = user
        attachment.form_answer = form_answer
        attachment.original_filename = filename
        attachment.save!

        # Create support letter
        support_letter = form_answer.support_letters.new
        support_letter.user = user
        support_letter.manual = true
        support_letter.first_name = first_name
        support_letter.last_name = last_name
        support_letter.relationship_to_nominee = relationship
        support_letter.support_letter_attachment = attachment
        support_letter.save!

        # Clean up temp file
        File.delete(tmp_file_path) if File.exist?(tmp_file_path)

        # Return hash for document
        {
          support_letter_id: support_letter.id,
          first_name: support_letter.first_name,
          last_name: support_letter.last_name,
          relationship_to_nominee: support_letter.relationship_to_nominee,
          letter_of_support: support_letter.support_letter_attachment.id
        }
      rescue => e
        log("Error creating support letter: #{e.message}", :error)
        log("Backtrace: #{e.backtrace.first(3).join("\n")}", :error)
        File.delete(tmp_file_path) if tmp_file_path && File.exist?(tmp_file_path)
        nil
      end
    end

    def download_file_from_url(url)
      return nil if url.blank?

      require 'net/http'
      require 'uri'
      require 'open-uri'
      require 'fileutils'

      begin
        original_url = url.strip
        uri = URI.parse(original_url)

        # Handle Google Drive file URLs - convert to direct download
        drive_hosts = ['drive.google.com']
        if drive_hosts.include?(uri.host)
          if uri.path.include?('/file/d/')
            file_id = uri.path.match(/\/file\/d\/([a-zA-Z0-9_-]+)/)
            if file_id
              # Convert to direct download URL
              download_url = "https://drive.google.com/uc?export=download&id=#{file_id[1]}"
              uri = URI.parse(download_url)
              log("Converting Google Drive URL to direct download: #{download_url}")
            end
          end
        end

        # Handle Google Docs URLs - convert to export format
        docs_hosts = ['docs.google.com']
        if docs_hosts.include?(uri.host)
          # Convert Google Docs view URL to export URL
          if uri.path.include?('/document/d/')
            doc_id = uri.path.match(/\/document\/d\/([a-zA-Z0-9_-]+)/)
            if doc_id
              # Try PDF first, then docx
              export_url = "https://docs.google.com/document/d/#{doc_id[1]}/export?format=pdf"
              uri = URI.parse(export_url)
              log("Converting Google Docs URL to PDF export: #{export_url}")
            end
          end
        end

        # Create temp file with a temporary name (we'll rename it after detecting content type)
        tmp_file_path = Rails.root.join("tmp", "support_letter_#{SecureRandom.hex(8)}")

        # Ensure tmp directory exists
        FileUtils.mkdir_p(File.dirname(tmp_file_path))

        # Download the file with timeout and redirect handling
        downloaded = false
        max_retries = 2
        retry_count = 0
        content_type = nil

        begin
          # Use an explicit URI instance to avoid Kernel#open shell semantics
          response = URI(uri.to_s).open(
               read_timeout: 60,
               'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36')

          # Get content type from response
          content_type = response.content_type if response.respond_to?(:content_type)
          content_type ||= response.meta['content-type'] if response.respond_to?(:meta) && response.meta
          content_type ||= response.meta['Content-Type'] if response.respond_to?(:meta) && response.meta

          # Check if we got HTML instead of file (common when file is not public)
          content = response.read

          # If we couldn't get content type from headers, try to detect from content
          if content_type.blank? && content.present?
            content_type = detect_content_type_from_bytes(content)
          end

          # Check if response is HTML (Google error page)
          if content.start_with?('<!DOCTYPE') || content.start_with?('<html') || content.include?('Sign in')
            log("ERROR: Received HTML instead of file. The file may not be publicly accessible.", :error)
            log("Please ensure the file is shared with 'Anyone with the link can view'", :error)
            File.delete(tmp_file_path) if File.exist?(tmp_file_path)
            return nil
          end

          File.open(tmp_file_path, 'wb') do |local_file|
            local_file.write(content)
          end
          downloaded = true
        rescue OpenURI::HTTPError => e
          # If PDF export fails for Google Docs, try DOCX
          begin
            original_uri = URI.parse(original_url.to_s)
            original_host = original_uri.host
          rescue URI::InvalidURIError
            original_host = nil
          end

          allowed_google_docs_hosts = ['docs.google.com']

          if retry_count < max_retries &&
             uri.to_s.include?('format=pdf') &&
             original_host && allowed_google_docs_hosts.include?(original_host)
            log("PDF export failed, trying DOCX format", :warn)
            doc_id = original_url.match(/\/document\/d\/([a-zA-Z0-9_-]+)/)
            if doc_id
              export_url = "https://docs.google.com/document/d/#{doc_id[1]}/export?format=docx"
              uri = URI.parse(export_url)
              retry_count += 1
              retry
            end
          else
            log("HTTP Error downloading file: #{e.message}", :error)
            if e.io.respond_to?(:status)
              log("Status: #{e.io.status.join(' ')}", :error)
            end
            raise e
          end
        rescue SocketError, Errno::ECONNREFUSED => e
          log("Connection error downloading file: #{e.message}", :error)
          raise e
        end

        if downloaded && File.exist?(tmp_file_path) && File.size(tmp_file_path) > 0
          # Determine file extension from content type or URL
          extension = determine_file_extension(content_type, original_url)

          # Rename file with proper extension
          final_file_path = "#{tmp_file_path}.#{extension}"
          File.rename(tmp_file_path, final_file_path)

          log("Downloaded file from #{original_url} (#{File.size(final_file_path)} bytes) to #{final_file_path} (content-type: #{content_type}, extension: #{extension})")
          final_file_path.to_s
        else
          log("Downloaded file appears to be empty or missing", :error)
          File.delete(tmp_file_path) if File.exist?(tmp_file_path)
          nil
        end
      rescue => e
        log("Error downloading file from #{url}: #{e.message}", :error)
        File.delete(tmp_file_path) if defined?(tmp_file_path) && tmp_file_path && File.exist?(tmp_file_path)
        nil
      end
    end

    def detect_content_type_from_bytes(content)
      return nil if content.blank? || content.length < 4

      # Check magic bytes (file signatures)
      header = content[0..15].unpack('C*')

      # PDF: starts with %PDF
      return 'application/pdf' if content.start_with?('%PDF')

      # DOCX: ZIP file with specific structure (starts with PK\x03\x04)
      if content.start_with?("PK\x03\x04")
        # Check if it's a DOCX by looking for word/ in the ZIP structure
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' if content.include?('word/')
        return 'application/zip'
      end

      # DOC: Microsoft Office legacy format (OLE2 compound document)
      if content[0..7] == "\xD0\xCF\x11\xE0\xA1\xB1\x1A\xE1"
        return 'application/msword'
      end

      # JPEG: starts with FF D8 FF
      return 'image/jpeg' if header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF

      # PNG: starts with 89 50 4E 47
      return 'image/png' if header[0] == 0x89 && header[1] == 0x50 && header[2] == 0x4E && header[3] == 0x47

      # Plain text: check if it's mostly printable ASCII
      if content.force_encoding('UTF-8').valid_encoding? && content.scan(/[[:print:]\n\r\t]/).length.to_f / content.length > 0.9
        return 'text/plain'
      end

      nil
    end

    def determine_file_extension(content_type, url)
      # First try to get extension from content type
      if content_type.present?
        case content_type.downcase
        when /pdf/
          return 'pdf'
        when /msword|wordprocessingml|application\/vnd\.openxmlformats-officedocument\.wordprocessingml/
          return 'docx'
        when /text\/plain/
          return 'txt'
        when /image\/jpeg/
          return 'jpg'
        when /image\/png/
          return 'png'
        end
      end

      # Fallback to URL pattern matching
      case url.to_s
      when /\.pdf/i
        'pdf'
      when /\.docx/i
        'docx'
      when /\.doc\b/i
        'doc'
      when /\.txt/i
        'txt'
      when /\.jpg|\.jpeg/i
        'jpg'
      when /\.png/i
        'png'
      when /docs\.google\.com.*format=docx/
        'docx'
      when %r{\Ahttps?://docs\.google\.com\b}
        'pdf' # Default for Google Docs
      else
        'pdf' # Safe default
      end
    end

    def extract_filename_from_url(url)
      return "letter_of_support.pdf" if url.blank?

      begin
        uri = URI.parse(url.strip)

        # Try to get filename from URL path
        if uri.path.present?
          filename = File.basename(uri.path)
          # Ensure filename has an extension
          if filename.present? && filename != '/' && filename.include?('.')
            return filename
          end
        end

        # For Google Docs, use a default name
        if uri.host == 'docs.google.com'
          return "google_doc_letter.pdf"
        end

        # Default fallback
        extension = determine_file_extension(nil, url)
        "letter_of_support.#{extension}"
      rescue
        "letter_of_support.pdf"
      end
    end

    def create_eligibility(form_answer, user)
      eligibility = form_answer.build_form_basic_eligibility
      eligibility.account = user.account
      eligibility.save_as_eligible!
    end

    def submit_application(form_answer)
      ::ManualUpdaters::SubmitApplication.new(form_answer).run!
    end

    def map_activity(activity_value)
      return nil if activity_value.blank?

      activity_value = activity_value.strip

      # Check if it's already a key
      if NomineeActivityHelper::ACTIVITY_MAPPINGS.key?(activity_value)
        return activity_value
      end

      # Try to lookup by label
      activity = NomineeActivityHelper.lookup_key_for_label(activity_value)
      if activity
        return activity
      end

      # If not found, try case-insensitive match
      matched = NomineeActivityHelper::ACTIVITY_MAPPINGS.detect do |k, v|
        v.downcase == activity_value.downcase
      end

      if matched
        return matched.first
      end

      log("Warning: Activity not found: #{activity_value}, using 'OTH'", :warn)
      'OTH'
    end

    def map_how_did_you_hear(value)
      return [{ "type": "other" }] if value.blank?

      value = value.strip.downcase

      case value
      when /national.*newspaper/i
        [{ "type": "national_newspaper" }]
      when /local.*newspaper/i
        [{ "type": "local_newspaper" }]
      when /tv|radio|television/i
        [{ "type": "tv_radio" }]
      when /internet|online|web/i
        [{ "type": "internet" }]
      when /word.*mouth/i
        [{ "type": "word_of_mouth" }]
      when /previous.*winner|previous.*entrant/i
        [{ "type": "previous_winner" }]
      when /voluntary.*organisation|charity/i
        [{ "type": "charity" }]
      when /event/i
        [{ "type": "event" }]
      when /library/i
        [{ "type": "library" }]
      when /council/i
        [{ "type": "council" }]
      else
        [{ "type": "other" }]
      end
    end

    def split_name(full_name)
      return ["Imported", "User"] if full_name.blank?

      parts = full_name.strip.split(/\s+/)
      first_name = parts[0] || "Imported"
      last_name = parts[1..-1].join(" ").presence || "User"

      [first_name, last_name]
    end

    def prepare_value(value)
      return nil if value.blank?
      value.to_s.strip.gsub(/[\u200B-\u200D\uFEFF]/, '')
    end

    def resolve_award_year
      year = options[:award_year]
      return year if year.is_a?(AwardYear)
      return AwardYear.where(year: year).first_or_create if year.is_a?(Integer)
      AwardYear.current
    end

    def log(message, level = :info)
      case level
      when :error
        Rails.logger.error(message)
        puts "[ERROR] #{message}"
      when :warn
        Rails.logger.warn(message)
        puts "[WARN] #{message}"
      else
        Rails.logger.info(message)
        puts "[INFO] #{message}" unless Rails.env.test?
      end
    end
  end
end
