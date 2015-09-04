require 'tgp_async'

module Tgp::Push
  class ChannelJob < Tgp::Async::BaseJob
    def self.async_message(channel_name, message=nil, sound=nil, ttl=nil,  force=false, default_message=nil, user_data=nil)

      # because this is async, we need to figure out the original time based off of ttl and pass that through

      if ttl  
        expire_time_i = (Time.zone.now + ttl).to_i
      else
        expire_time_i = nil
      end

      safe_user_data = user_data.nil? ? nil : user_data.to_json

      push(:channel_name => channel_name, :message => message, :sound => sound, :expire_time_i=>expire_time_i,  
           :force=>force, :default_message => default_message, :user_data => safe_user_data)
    end

    def self.perform(msg)
      #puts "PERFORMING CHANNEL JOB #{msg.inspect}"
      message = msg["message"]
      channel_name = msg["channel_name"]
      sound = msg["sound"]
      force = msg["force"]
      default_message = msg["default_message"]
      expire_time_i = msg["expire_time_i"]
      user_data = msg["user_data"]

      return if message.nil? && default_message.nil?
      return if channel_name.nil?

      user_data = user_data.nil? ? nil : JSON.parse(user_data)

      ttl = nil
      ttl = (Time.zone.at(expire_time_i) - Time.zone.now) if expire_time_i # reget the ttl based off current time

      options = {}
      options[:sound] = sound
      options[:force] = force
      options[:ttl] = ttl
      options[:default_message] = default_message
      options[:user_data] = user_data if user_data

      Tgp::Push::Channel.each(channel_name) do |user_id|
        #puts "GOT USERID #{user_id}"
        Tgp::Push::message(user_id, message, nil, options) # call this so it fans out
      end
    end
  end
end
