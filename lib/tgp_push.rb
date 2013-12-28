require "tgp/push/engine"
require "tgp/push/model/user"
require "tgp/push/model/channel"
require "tgp/push/model/device"
require "tgp/push/model/channel_notification"
require "tgp/push/model/channel_user"
require "tgp/push/job/channel_job"
require "tgp/push/notification"

module Tgp
  module Push
    DEVICE_TYPE_IOS = 1
    DEVICE_TYPE_ANDROID = 2
    DEVICE_TYPE_SMS = 3

    def self.register(user_id, device_token, device_type)
      Tgp::Push::Device::register(user_id, device_token, device_type)
    end

    def self.unregister(user_id, device_token, device_type)
      Tgp::Push::Device::unregister(user_id, device_token, device_type)
    end

    def self.message(user_id, message, badge_count=nil, params={})
      Tgp::Push::Notification::message(user_id, message, badge_count, params)
    end

    def self.badge(user_id, badge_count, params={})
      Tgp::Push::Notification::badge(user_id, badge_count, params)
    end

    def self.badge(user_id, badge_count, params={})
      Tgp::Push::Notification::badge(user_id, badge_count, params)
    end

    def self.channel_message(name, message, params={})
      Tgp::Push::Channel.each(name) do |user_id|
        Tgp::Push::message(user_id, message, params)
      end
    end

    def self.subscribe_to_channel(user_id, name, only_if_exists=false)
      Tgp::Push::Channel::subscribe(user_id, name, only_if_exists)
    end

    def self.unsubscribe_from_channel(user_id, name)
      Tgp::Push::Channel::unsubscribe(user_id, name)
    end
  end
end
