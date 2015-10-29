module Tgp
  module Push
    module Model
      module Device
        extend ActiveSupport::Concern
      
        included do
          self.table_name = 'tgp_push_devices'

          attr_accessible :device_token,
                          :device_type,
                          :is_active,
                          :user_id,
                          :target_arn,
                          :platform_app_arn
      
          belongs_to :user

          validate :device_token, :presence => true
          validate :device_type,  :presence => true, :inclusion=> { :in => [ Tgp::Push::DEVICE_TYPE_IOS, Tgp::Push::DEVICE_TYPE_ANDROID] }
        end
      
        module ClassMethods

          # Maybe this needs to be threadsafe?  Worry about it later
          def the_sns
           @sns ||= AWS::SNS.new( :access_key_id => ::AWS_ACCESS_KEY_ID, :secret_access_key => ::AWS_SECRET_KEY)
          end

          def arn_from_device_type(device_type)
            arn = nil

            arn = Tgp::Push::Engine.config.tgp_push_apns_arn if Tgp::Push::DEVICE_TYPE_IOS == device_type
            arn = Tgp::Push::Engine.config.tgp_push_gcm_arn if Tgp::Push::DEVICE_TYPE_ANDROID == device_type

            Rails.logger("You need to set one of Tgp::Push::Engine.config.tgp_push_apns_arn or Tgp::Push::Engine.config.tgp_push_gcm_arn") if arn.nil?

            arn
          end

          def register(user_ids, device_token, device_type, options={})
            platform_app_arn = arn_from_device_type(device_type)

            return if platform_app_arn.nil?
            return if device_token.blank?

            device_token = device_token.strip

            #puts "CHECK OUT MY OPTIONS 1 #{options.inspect}"
            user_ids = [user_ids] unless user_ids.is_a? Array
            user_ids = user_ids.map { |user_id| user_id.is_a?(Integer) ? user_id : user_id.id }

            if options.keys.map { |x| x.to_sym} & [:tz, :start_time, :end_time]
              for user_id in user_ids
                #puts "CHECK OUT MY OPTIONS #{options.inspect}"
                pref = Tgp::Push::UserPref.find_or_create_unique(:user_id => user_id)

                pref.tz = options[:tz] || options["tz"] if options[:tz] || options["tz"]
                pref.start_time = options[:start_time] || options["start_time"] if options[:start_time] || options["start_time"]
                pref.end_time = options[:end_time] || options["end_time"] if options[:end_time] || options["end_time"]

                if !pref.save
                  raise Exception, pref.errors.full_messages.join(", ")
                end
              end
            end

            endpoint = the_sns.client.create_platform_endpoint(platform_application_arn: platform_app_arn, token: device_token)
            if endpoint
              the_sns.client.set_endpoint_attributes(:endpoint_arn => endpoint[:endpoint_arn].to_s, :attributes => { "Enabled" => "true"})
            end

            unless options[:keep_registrations]
              #update_all({:is_active => false}, {:device_token => device_token, :device_type => device_type}) unless options[:keep_registrations]
              destroy_all(["device_token = ? and device_type = ? and user_id not in (?)", device_token, device_type, user_ids])
            end

            user_ids.each do |user_id|
              device = find_or_create_unique_with_create_options({:user_id => user_id, :device_token => device_token, :device_type => device_type}, { :platform_app_arn => platform_app_arn })
              device.is_active = endpoint ? true : false
              device.target_arn = endpoint[:endpoint_arn] if endpoint
              device.platform_app_arn = platform_app_arn
              device.save
            end
          end

          def unregister(user_ids, device_token, device_type, options={})
            platform_app_arn = arn_from_device_type(device_type)
            user_ids = [user_ids] unless user_ids.is_a? Array
            user_ids = user_ids.map { |user_id| user_id.is_a?(Integer) ? user_id : user_id.id }

            devices = where(:device_token => device_token, :device_type => device_type, :platform_app_arn => platform_app_arn)

            if devices.count > 0
              devices.each do |device|
                if !options[:keep_registrations] || user_ids.include?(device.user_id)
                  the_sns.client.delete_endpoint(:endpoint_arn => device.target_arn) if device.target_arn
                  device.destroy
                end
              end
            end
          end
        end

        def message(message=nil, badge_count=nil, options={})
          return if !Tgp::Push::Engine.config.tgp_push_enabled
          return if !is_active

          begin
            message_safe(message, badge_count, options)

          rescue AWS::SNS::Errors::EndpointDisabled, AWS::Core::OptionGrammar::FormatError => ed
            puts  "#{self.inspect} has been deactivated"
            self.update_attribute(:is_active, false)
          end
        end

        def message_safe(message=nil, badge_count=nil, options={})
          sound = options[:sound]
          content_available = options[:content_available] || false
          category = options[:category]
          expire_time = options[:expire_time]
          default_message = options[:default_message]
          user_data = options[:user_data]

          return if !Tgp::Push::Engine.config.tgp_push_enabled
          return if !is_active

          #puts "SOUND IS #{sound}"
          #puts "USER DATA IS #{user_data.inspect}"

          return if message.nil? && badge_count.nil? && content_available.nil? && default_message.nil?
          return if expire_time && (expire_time < Time.zone.now)

          #puts "BADGE COUNT #{badge_count}"

          platform_arn = self.class.arn_from_device_type(self.device_type)
          return if (platform_arn.nil? || platform_arn != self.platform_app_arn)

          platform = platform_arn.split("/")[1]

          # refactor here for ios/android/text
          aps_package = {}
          aps_package["aps"] = {}
          aps_package["aps"]["alert"] = message if message
          aps_package["aps"]["badge"] = badge_count if badge_count
          aps_package["aps"]["sound"] = sound if sound
          aps_package["aps"]["content-available"] = 1 if content_available
          aps_package["aps"]["category"] = category if category
          
          if user_data
            user_data.each_pair do |k,v|
              aps_package[k.to_s] = v
            end
          end

          package = {}
          package["default"] = default_message ? default_message : "The default #{Time.now}"
          package[platform]  = aps_package.to_json unless message.nil? && badge_count.nil? && !content_available

          #puts "2 => #{package.to_json}"

          log_push_to_db(package)
          self.class.the_sns.client.publish(target_arn: self.target_arn, message: package.to_json, message_structure: 'json' )
        end

        def badge_count(count)
          self.message(nil, count)
        end

private

        def log_push_to_db(package)
          return unless Tgp::Push::Engine.config.tgp_push_db_logging_enabled

          begin
            push_log = Tgp::Push::Log.new
            push_log.device_id = self.id
            push_log.package   = package.to_json
            push_log.save
          rescue StandardError => error
            puts "Tgp::Push::Device.message error logging push: #{error}"
          end
        end


      end
    end
  end
end
