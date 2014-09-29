module Tgp
  module Push
    class Notification

      def self.default_options
        { :ttl               => Tgp::Push::Engine.config.tgp_push_ttl,
          :sound             => Tgp::Push::Engine.config.tgp_push_sound,
          :default_message   => nil,
          :content_available => false,
          :force             => false,
          :user_data         => nil,
          :category          => nil }
      end

      def self.channel_message(channel_name, message, options={})
        return if !Tgp::Push::Engine.config.tgp_push_enabled

        options = default_options.merge! options

        ttl               = options[:ttl] 
        sound             = options[:sound]
        force             = options[:force]
        default_message   = options[:default_message]
        content_available = options[:content_available]
        user_data         = options[:user_data]
        category          = options[:category]

        Tgp::Push::ChannelJob::async_message(channel_name, message, sound, ttl, force, default_message, user_data)
      end

      def self.message(user_id, message, badge_count=nil, options={})
        return if !Tgp::Push::Engine.config.tgp_push_enabled

        #puts "A BADGE COUNT #{badge_count}"
        user_id = user_id.is_a?(Integer) ? user_id : user_id.id

        count = 0
        options = default_options.merge! options

        ttl               = options[:ttl] 
        sound             = options[:sound]
        force             = options[:force]
        default_message   = options[:default_message]
        content_available = options[:content_available]
        user_data         = options[:user_data]
        category          = options[:category]

        start_time = Tgp::Push::Engine.config.tgp_push_start_message_time
        end_time = Tgp::Push::Engine.config.tgp_push_end_message_time

        tz = Time.zone

        user_pref = UserPref.where(:user_id => user_id).first

        if user_pref
          tz = user_pref.tz if user_pref.tz
          start_time = user_pref.start_time if user_pref.start_time
          end_time = user_pref.end_time if user_pref.end_time
        end

        end_time = 2400 if start_time && end_time.nil?
        start_time = 0 if end_time && start_time.nil?

        #puts "PRE SOUND #{sound}"

        if start_time && end_time && !force
          user_time = Time.zone.now.in_time_zone(tz)
          hours = user_time.hour
          minutes = user_time.min
          full_time = hours * 100 + minutes

          if start_time > end_time # roll over
            if (full_time > end_time) && (full_time < start_time)
              sound = nil
            end
              
          else

            if (full_time > end_time) || (full_time < start_time)
              sound = nil
            end
          end
        end

        #puts "POST SOUND #{sound}"

        return if message.nil? && badge_count.nil? && !content_available && default_message.nil? # nothing to do, return

        expire_time = ttl.nil? ? nil : Time.zone.now + ttl

        devices = Tgp::Push::Device::where(:user_id => user_id, :is_active => true).each do |d|
          Tgp::Push::DeviceJob::async_message(d.id, message, badge_count, sound, content_available, category, expire_time, default_message, user_data)
          count = count + 1
        end

        Rails.logger.debug("User #{user_id} has no registered/active push devices!") if count == 0
      end

      def self.alert(user_id, the_message, options={})
        self.message(user_id, the_message, nil, options)
      end

      def self.badge(user_id, count, options={})
        self.message(user_id, nil, options)
      end


    end
  end
end
