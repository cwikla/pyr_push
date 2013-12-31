require 'tgp_async'

module Tgp::Push
  class DeviceJob < Tgp::Async::BaseJob

    def self.async_message(device_id, message=nil, badge_count=nil, time_to_i=nil)
      time_to_i ||= Time.now.to_i
      push(:device_id => device_id, :message => message, :badge_count => badge_count, :time_to_i => time_to_i)
    end

    def self.perform(msg)
      device_id = msg["device_id"]
      message = msg["message"]
      badge_count = msg["badge_count"]
      time_to_i = msg["time_to_i"]

      return if device_id.nil?
      return if time_to_i.nil?

      return if message.nil? && badge_count.nil?

      if Tgp::Push::Engine::config.tgp_push_message_lifetime # ok to be nil, but not recommeded
        if (Time.now.to_i - time_to_i.to_i) > Tgp::Push::Engine::config.tgp_push_message_lifetime
          message = nil # nil out message, leave badge_count
        end
      end

      return if message.nil? && badge_count.nil? # nothing to see here

      device = Tgp::Push::Device.find(device_id)
      device.message(message, badge_count)
    end
  end
end
