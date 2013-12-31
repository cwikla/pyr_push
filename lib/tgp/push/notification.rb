module Tgp
  module Push
    class Notification
      def self.channel_message(channel_name, message, time_to_i=nil)
        Tgp::Push::ChannelJob::async_message(channel_name, message, time_to_i)
      end

      def self.message(user_id, message, badge_count=nil, time_to_i=nil)
        #puts "A BADGE COUNT #{badge_count}"
        user_id = user_id.is_a?(Integer) ? user_id : user_id.id

        count = 0

        start_time = Tgp::Push::Engine.config.tgp_push_default_start_message_time
        end_time = Tgp::Push::Engine.config.tgp_push_default_end_message_time
        tz = Time.zone

        user_pref = UserPref.where(:user_id => user_id).first

        if user_pref
          tz = user_pref.tz if user_pref.tz
          start_time = user_pref.start_time if user_pref.start_time
          end_time = user_pref.end_time if user_pref.end_time
        end

        end_time = 2400 if start_time && end_time.nil?
        start_time = 0 if end_time && start_time.nil?

        if start_time && end_time
          user_time = Time.zone.now.in_time_zone(tz)
          hours = user_time.hour
          minutes = user_time.min
          full_time = hours * 100 + minutes

          if start_time > end_time # roll over
            if (full_time > end_time) && (full_time < start_time)
              message = nil # wipe out message, leave badge count
            end
              
          else

            if (full_time > end_time) || (full_time < start_time)
              message = nil # wipe out message, leave badge count
            end
          end
        end

        return if message.nil? && badge_count.nil? # nothing to do, return

        devices = Tgp::Push::Device::where(:user_id => user_id, :is_active => true).each do |d|
          Tgp::Push::DeviceJob::async_message(d.id, message, badge_count, time_to_i)
          count = count + 1
        end

        Rails.logger.debug("User #{user_id} has no registered/active push devices!") if count == 0
      end

      def self.alert(user_id, the_message, time_to_i=nil)
        self.message(user_id, the_message, nil, time_to_i)
      end

      def self.badge(user_id, count, time_to_i=nil)
        self.message(user_id, nil, time_to_i)
      end

    end
  end
end
