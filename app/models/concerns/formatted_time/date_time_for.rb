module FormattedTime::DateTimeFor
  extend ActiveSupport::Concern

  module ClassMethods
    def formatted_time_for(*attrs)
      mod = Module.new do
        attrs.each do |attr|
          define_method("formatted_#{attr}=") do |value|
            hours, min = value.match(/(\d{2})\:(\d{2})/).try(:captures)

            seconds = if hours && min
              hours.to_i * 3600 + min.to_i * 60
            end

            self.public_send("#{attr}=", seconds)
          end

          define_method("formatted_#{attr}") do
            seconds = public_send(attr)

            if seconds
              hours, minutes = seconds.divmod(3600)
              '%02d:%02d' % [hours, (minutes / 60)]
            end
          end
        end
      end

      include mod
    end

    def formatted_date_for(*attrs)
      mod = Module.new do
        attrs.each do |attr|
          attr_accessible "formatted_#{attr}" if respond_to?(:attr_accessible)

          define_method("formatted_#{attr}=") do |value|
            date = Date.strptime(value, "%d/%m/%Y") rescue nil
            self.public_send("#{attr}=", date)
          end

          define_method("formatted_#{attr}") do
            date = public_send(attr)
            date && date.strftime("%d/%m/%Y")
          end
        end
      end

      include mod
    end

    def date_time_for(*attrs)
      attrs.each do |attr|
        day = :"#{attr}_day"
        month = :"#{attr}_month"
        year = :"#{attr}_year"
        date = :"#{attr}_date"
        time = :"#{attr}_time"

        attr_accessible "formatted_#{day}", "formatted_#{month}",
                        "formatted_#{year}", "formatted_#{time}" if respond_to?(:attr_accessible)

        formatted_time_for time
        formatted_date_for date

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{date}
            value = #{attr}
            if value
              value = value.in_time_zone(Time.zone)
              value.to_date
            end
          end

          def #{day}
            value = #{attr}
            if value
              value = value.in_time_zone(Time.zone)
              value.to_date.strftime("%d")
            end
          end

          def #{month}
            value = #{attr}
            if value
              value = value.in_time_zone(Time.zone)
              value.to_date.strftime("%m")
            end
          end

          def #{year}
            value = #{attr}
            if value
              value = value.in_time_zone(Time.zone)
              value.to_date.strftime("%Y")
            end
          end

          def #{time}
            value = #{attr}
            if value
              value = value.in_time_zone(Time.zone)

              value.to_i - value.beginning_of_day.to_i
            end
          end

          def #{day}=(value)
            if #{attr}
              seconds = #{attr}.hour.hours + #{attr}.min.minutes
            end

            day = value
            month = self.public_send("#{attr}_month")
            year = self.public_send("#{attr}_year")

            if day && month && year
              zone = Time.zone
              self.#{attr} = zone.local(year, month, day)

              self.#{attr} += seconds if #{attr} && seconds
            else
              # self.#{attr} = nil
            end
          end

          def #{month}=(value)
            if #{attr}
              seconds = #{attr}.hour.hours + #{attr}.min.minutes
            end

            month = value
            day = self.public_send("#{attr}_day")
            year = self.public_send("#{attr}_year")

            if value && day && year
              zone = Time.zone
              self.#{attr} = zone.local(year, month, day)

              self.#{attr} += seconds if #{attr} && seconds
            else
              # self.#{attr} = nil
            end
          end

          def #{year}=(value)
            if #{attr}
              seconds = #{attr}.hour.hours + #{attr}.min.minutes
            end

            year = value
            day = self.public_send("#{attr}_day")
            month = self.public_send("#{attr}_month")

            if day && month && year
              zone = Time.zone
              self.#{attr} = zone.local(year, month, day)

              self.#{attr} += seconds if #{attr} && seconds
            else
              # self.#{attr} = nil
            end
          end

          def #{time}=(value)
            time = if #{date}
              Time.zone.local(#{date}.year, #{date}.month, #{date}.day)
            else
              nil
            end

            self.#{attr} = time.to_time + value.to_i if time && value
          end
        RUBY
      end
    end
  end
end
