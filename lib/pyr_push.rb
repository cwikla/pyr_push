require "pyr/push/engine"
require "pyr/push/model/user"
require "pyr/push/model/channel"
require "pyr/push/model/device"
require "pyr/push/model/channel_notification"
require "pyr/push/model/channel_user"
require "pyr/push/model/user_pref"
require "pyr/push/model/log"
require "pyr/push/job/channel_job"
require "pyr/push/job/device_job"
require "pyr/push/notification"

module Pyr
  module Push
    DEVICE_TYPE_IOS = 1
    DEVICE_TYPE_ANDROID = 2
    DEVICE_TYPE_SMS = 3

    # options = tz (timezone), start_time, end_time (in 300, 8300, 1215 format) for when to mute the sound

    def self.register(user_id, device_token, device_type, options={})
      Pyr::Push::Device::register(user_id, device_token, device_type, options)
    end

    def self.unregister(user_id, device_token, device_type, options={})
      Pyr::Push::Device::unregister(user_id, device_token, device_type, options={})
    end

    # options = :ttl => time to live in seconds, :sound => soundfile on app or  "default" or nil (for nothing), and :force to override the muted sound, and :user_data

    def self.message(user_id, message, badge_count=nil, options={})
      Pyr::Push::Notification::message(user_id, message, badge_count, options)
    end

    def self.message_device_ids(device_ids, message, badge_count=nil, options={})
      Pyr::Push::Notification::message_device_ids(device_ids, message, badge_count, options)
    end

    def self.badge(user_id, badge_count, options={})
      Pyr::Push::Notification::badge(user_id, badge_count, options)
    end

    def self.channel_message(name, message, options={})
      Pyr::Push::Notification::channel_message(name, message, options)
    end

    def self.subscribe_to_channel(user_id, name, only_if_exists=false)
      Pyr::Push::Channel::subscribe(user_id, name, only_if_exists)
    end

    def self.unsubscribe_from_channel(user_id, name)
      Pyr::Push::Channel::unsubscribe(user_id, name)
    end
  end
end
