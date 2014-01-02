require 'tgp_async'

module Tgp::Push
  class ChannelJob < Tgp::Async::BaseJob
    def self.async_message(channel_name, message, sound, ttl, force)

      # because this is async, we need to figure out the original time based off of ttl and pass that through

      if ttl  
        expire_time_i = (Time.zone.now + ttl).to_i
      else
        expire_time_i = nil
      end

      push(:channel_name => channel_name, :message => message, :sound => sound, :expire_time_i=>expire_time_i, :force=>force)
    end

    def self.perform(msg)
      #puts "PERFORMING CHANNEL JOB #{msg.inspect}"
      message = msg["message"]
      channel_name = msg["channel_name"]
      sound = msg["sound"]
      force = msg["force"] || false
      expire_time_i = msg["expire_time_i"]

      return if message.nil?
      return if channel_name.nil?

      ttl = nil
      ttl = (Time.zone.at(expire_time_i) - Time.zone.now) if expire_time_i # reget the ttl based off current time

      options = {}
      options[:sound] = sound if sound
      options[:force] = force
      options[:ttl] = ttl

      Tgp::Push::Channel.each(channel_name) do |user_id|
        #puts "GOT USERID #{user_id}"
        Tgp::Push::message(user_id, message, nil, options) # call this so it fans out
      end
    end
  end
end
