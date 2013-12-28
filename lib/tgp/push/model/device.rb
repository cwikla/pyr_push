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
                          :target_arn
      
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

          def register(user_id, device_token, device_type)
            user_id = user_id.is_a?(Integer) ? user_id : user.id

            device = find_or_create_unique(:user_id => user_id, :device_token => device_token, :device_type => device_type)

            endpoint = the_sns.client.create_platform_endpoint(platform_application_arn: arn_from_device_type(device_type), token: device_token)

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

        def message(message=nil, badge_count=nil, params={})

          platform_arn = self.class.arn_from_device_type(self.device_type)
          return if platform_arn.nil?

          platform = platform_arn.split("/")[1]

          aps_package = {}
          aps_package["aps"] = {}
          aps_package["aps"]["alert"] = message if message
          aps_package["aps"]["badge"] = badge_count if badge_count

          package = {}
          package["default"] = "The defult #{Time.now}"
          package[platform] =  aps_package.to_json

          puts "2 => #{package.to_json}"

          self.class.the_sns.client.publish(target_arn: self.target_arn, message: package.to_json, message_structure: 'json' )
        end

        def badge_count(count, params={})
          self.message(nil, count, params)
        end

      end
    end
  end
end
