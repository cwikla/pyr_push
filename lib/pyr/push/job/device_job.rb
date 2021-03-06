require 'pyr_async'

module Pyr::Push
  class DeviceJob < Pyr::Async::BaseJob

    def self.async_message(device_id, message=nil, badge_count=nil, sound=nil, content_available=false, category=nil, expire_time=nil, default_message=nil, user_data=nil)
      expire_time_i = nil
      expire_time_i = expire_time.to_i if expire_time # make sure we are safe to pass through

      safe_user_data = user_data.nil? ? nil : user_data.to_json

      push(:device_id => device_id, :message => message, :badge_count => badge_count,
           :sound => sound, :content_available => content_available, :category => category,
           :expire_time_i => expire_time_i, :default_message => default_message, :user_data => safe_user_data)
    end

    def self.perform(msg)
      device_id         = msg["device_id"]
      message           = msg["message"]
      badge_count       = msg["badge_count"]
      sound             = msg["sound"]
      content_available = msg["content_available"]
      category          = msg["category"]
      expire_time_i     = msg["expire_time_i"]
      default_message   = msg["default_message"]
      user_data         = msg["user_data"]

      return if device_id.nil?
      return if message.nil? && badge_count.nil? && !content_available && default_message.nil?

      user_data = user_data.nil? ? nil : JSON.parse(user_data)

      expire_time = nil
      expire_time = Time.zone.at(expire_time_i) if expire_time_i

      device = Pyr::Push::Device.find(device_id)
      device.message(message, badge_count, :sound => sound, :content_available => content_available, :category => category, :expire_time => expire_time, :default_message => default_message, :user_data => user_data)
    end
  end
end
