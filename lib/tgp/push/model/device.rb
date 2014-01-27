module Tgp
  module Push
    module Model
      module Device
        extend ActiveSupport::Concern
      
        included do
          #set_table_name "tgp_push_devices"
          self.table_name = 'tgp_push_devices'

          attr_accessible :device_token,
                          :device_type,
                          :is_active,
                          :user_id,
                          :target_arn,
                          :platform_app_arn
      
          #belongs_to :user

          validate :device_token, :presence => true
          validate :device_type,  :presence => true, :inclusion=> { :in => [ Tgp::Push::DEVICE_TYPE_IOS, Tgp::Push::DEVICE_TYPE_ANDROID] }
        end
      
        module ClassMethods

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

          def register(user_id, device_token, device_type, options={})
            platform_app_arn = arn_from_device_type(device_type)

            return if platform_app_arn.nil?

            #puts "CHECK OUT MY OPTIONS 1 #{options.inspect}"
            user_id = user_id.is_a?(Integer) ? user_id : user_id.id

            if options.keys.map { |x| x.to_sym} & [:tz, :start_time, :end_time]
              #puts "CHECK OUT MY OPTIONS #{options.inspect}"
              pref = Tgp::Push::UserPref.find_or_create_unique(:user_id => user_id)

              pref.tz = options[:tz] || options["tz"] if options[:tz] || options["tz"]
              pref.start_time = options[:start_time] || options["start_time"] if options[:start_time] || options["start_time"]
              pref.end_time = options[:end_time] || options["end_time"] if options[:end_time] || options["end_time"]

              if !pref.save
                raise Exception, pref.errors.full_messages.join(", ")
              end
            end


            device = find_or_create_unique(:device_token => device_token, :device_type => device_type)
            device.user_id = user_id
            device.platform_app_arn = platform_app_arn

            endpoint = the_sns.client.create_platform_endpoint(platform_application_arn: platform_app_arn, token: device_token)

            device.target_arn = endpoint[:endpoint_arn] if endpoint
            device.save

          end

          def unregister(user_id, device_token, device_type)
            user_id = user_id.is_a?(Integer) ? user_id : user.id

            device = where(:user_id => user_id, :device_token => device_token, :device_type => device_type).first
  
            if device
              the_sns.client.destroy_platform_endpoint(platform_application_arn: arn_from_device_type(device_type), token: device_token)
              device.destroy
            end
          end
        end

        def message(message=nil, badge_count=nil, sound=nil, expire_time=nil, user_data=nil)
          return if !Tgp::Push::Engine.config.tgp_push_enabled

          #puts "SOUND IS #{sound}"
          #puts "USER DATA IS #{user_data.inspect}"

          return if message.nil? && badge_count.nil?

          return if expire_time && (expire_time < Time.zone.now)

          #puts "BADGE COUNT #{badge_count}"

          platform_arn = self.class.arn_from_device_type(self.device_type)
          return if platform_arn.nil?

          platform = platform_arn.split("/")[1]

          # refactor here for ios/android/text
          aps_package = {}
          aps_package["aps"] = {}
          aps_package["aps"]["alert"] = message if message
          aps_package["aps"]["badge"] = badge_count if badge_count
          aps_package["aps"]["sound"] = sound if sound
          aps_package["aps"]["content-available"] = 1 if badge_count # if we have a badge_count, we have content
          
          if user_data
            user_data.each_pair do |k,v|
              aps_package[k.to_s] = v
            end
          end

          package = {}
          package["default"] = "The default #{Time.now}"
          package[platform] =  aps_package.to_json

          #puts "2 => #{package.to_json}"

          self.class.the_sns.client.publish(target_arn: self.target_arn, message: package.to_json, message_structure: 'json' )
        end

        def badge_count(count)
          self.message(nil, count)
        end

      end
    end
  end
end
