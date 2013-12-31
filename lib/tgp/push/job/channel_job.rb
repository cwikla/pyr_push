require 'tgp_async'

module Tgp::Push
  class ChannelJob < Tgp::Async::BaseJob
    def self.async_message(channel_name, message, time_to_i=nil)
      time_to_i ||= Time.now.to_i
      push(:channel_name => channel_name, :message => message, :time_to_i => time_to_i)
    end

    def self.perform(msg)
      #puts "PERFORMING CHANNEL JOB #{msg.inspect}"
      message = msg["message"]
      channel_name = msg["channel_name"]
      time_to_i = msg["time_to_i"]

      return if message.nil?
      return if channel_name.nil?
      return if time_to_i.nil?

      Tgp::Push::Channel.each(channel_name) do |user_id|
        #puts "GOT USERID #{user_id}"
        Tgp::Push::message(user_id, message, nil, time_to_i) # call this so it fans out
      end
    end
  end
end
