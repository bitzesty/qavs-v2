# Example of use:
#
# FormDataQueenAwardHolderDetailsRestorer.restore_with_blank_data
#
# FormDataQueenAwardHolderDetailsRestorer.restore_with_existing_data
#

class FormDataQueenAwardHolderDetailsRestorer
  class << self
    def with_blank
      FormAnswer.submitted
                .where("date(updated_at) >= ?", Date.new(2015,10,1))
                .select do |f|
                  f.document["queen_award_holder"].to_s == 'yes' &&
                  f.document["queen_award_holder_details"].blank?
                end.select do |f|
        f.versions.present? &&
        f.versions.select do |v|
          v.object.present? &&
          v.object["document"]["queen_award_holder_details"].present?
        end.count > 0
      end
    end

    def with_data
      FormAnswer.submitted
                .where("date(updated_at) >= ?", Date.new(2015,10,1))
                .select do |f|
                  f.document["queen_award_holder"].to_s == 'yes' &&
                  f.document["queen_award_holder_details"].present? &&
                  f.document["queen_award_holder_details"].any? do |t|
                    t["category"].blank?
                  end
                end.select do |f|
        f.versions.present? &&
        f.versions.select do |v|
          v.object.present? &&
          v.object["document"]["queen_award_holder_details"].present?
        end.count > 0
      end
    end

    def restore_with_blank_data
      restore(with_blank)
    end

    def restore_with_existing_data
      restore(with_data)
    end

    def restore(data)
      @corrected_ids = []

      if data.present?
        all_ids = data.map(&:id)

        puts ""
        puts "   FORMS with bad queen_award_holder_details detected! (#{data.count})"
        puts "   IDs: #{all_ids}"
        puts ""

        data.each do |form|
          run(form)
        end

        puts ""
        puts "   FIXED #{@corrected_ids.count} entries"
        puts "   FIXED IDs: #{@corrected_ids}"
        puts ""

        not_fixed_ids = all_ids - @corrected_ids

        puts ""
        puts "   NOT FIXED #{not_fixed_ids.count} entries"
        puts "   NOT FIXED IDs: #{not_fixed_ids}"
        puts ""
      else
        puts ""
        puts "   FORMS with bad queen_award_holder_details are not exist"
        puts ""
      end

      nil
    end

    def run(form)
      all_versions = form.versions.select do |v|
        v.object.present? &&
        v.object["document"]["queen_award_holder_details"].present?
      end.sort do |a, b|
        b.created_at <=> a.created_at
      end

      current = form.document['queen_award_holder_details']

      puts "------------------------------"
      puts "   FORM ID: #{form.id} "
      puts ""
      puts "   current: #{current}"
      puts ""
      puts "   VERSION LIST: "

      all_versions.each_with_index do |ver, index|
        mats = ver.object["document"]["queen_award_holder_details"]

        puts ""
        puts "     VERSION #{index + 1}, date: #{ver.created_at}: #{mats}"
        puts ""
      end

      print "Would you like to set one of versions? [y/n]: "
      resy = gets.chomp

      if resy.to_s == "y"
        puts "   VERSION SELECTION STARTED!"
      elsif resy.to_s == "n"
        puts "   Go Next Form!"
        return false
      end

      selected_version = nil

      all_versions.each_with_index do |v, index|
        next if selected_version.present?

        puts ""
        puts "   VERSION #{index + 1}, date: #{v.created_at}: #{v.object["document"]["queen_award_holder_details"]}"
        puts ""

        print "Select this version? [y/n]: "
        response = gets.chomp

        current_version = v.object["document"]["queen_award_holder_details"]

        case response
          when 'y'
            puts ""
            puts "   SELECTED VERSION: #{current_version}"
            puts ""

            print "Are you sure? [y/n]: "
            r = gets.chomp
            case r
              when 'y'
                selected_version = current_version

                puts "   VERSION SELECTED!"
              when 'n'
                puts "   Go Next version!"
            end

          when 'n'
            puts ""
            puts "   Skipping"
            puts ""
        end
      end

      puts ""
      puts "   selected_version: #{selected_version}"
      puts ""

        print "Restore it? [y/n]: "
        response = gets.chomp
        case response
          when 'y'
            puts ""
            puts "   RESTORE"
            puts ""

            form.document["queen_award_holder_details"] = selected_version
            form.save!

            @corrected_ids << form.id

            puts "|||||||||||||||||||||||||||||||||||||||||||||||||||"
            puts ""
            puts "   #{form.id} SAVED!"
            puts ""
            puts "|||||||||||||||||||||||||||||||||||||||||||||||||||"
            puts ""

            sleep 10

          when 'n'
            puts ""
            puts "   Skipping"
            puts ""
        end

      puts ""

      @corrected_ids
    end
  end
end
