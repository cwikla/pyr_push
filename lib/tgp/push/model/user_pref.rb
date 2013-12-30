module Tgp
  module Push
    module Model
      module UserPref
        extend ActiveSupport::Concern
      
        included do
          self.table_name = "tgp_push_user_prefs"

          attr_accessible :user_id,
                          :tz,
                          :start_time,
                          :end_time

          belongs_to :user

          validate :user, :presence => true

          validate :check_params
        end
      
        module ClassMethods
        end

        def check_params
          puts "UserPref => #{self.inspect}"
          if self.tz
            if !ActiveSupport::TimeZone.zones_map { |m| m.name }.include?(self.tz)
              self.errors[:tz] = "#{self.tz} is an invalid Time Zone"
            end
          end

          if self.start_time && self.end_time
            if self.start_time < 0
              self.start_time = 0
            end
            if self.start_time > 2359
              self.start_time = 2539
            end

            if self.end_time < 0
              self.end_time = 0
            end

            if self.end_time > 2359
              self.end_time = 2359
            end

            smin = self.start_time % 60
            smin = 59 if smin > 59

            emin = self.end_time % 60
            emin = 59 if emin > 59

            self.start_time = self.start_time / 100 * 100 + smin
            self.end_time = self.end_time / 100 * 100 + emin
          else
            puts "Setting errors"
            self.errors[:end_time] = "end_time must be set if you set start_time" if start_time
            self.errors[:start_time] = "start_time must be set if you set end_time" if end_time
          end

        end

      end
    end
  end
end