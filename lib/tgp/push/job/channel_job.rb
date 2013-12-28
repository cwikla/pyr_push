require 'tgp_async'

module Tgp::Push
  class ChannelJob < Tgp::Async::BaseJob
    def push(options)
      message_id = options[:message_id]
      channel_id = optinos[:channel_id]

      raise Exception.new, "Missing argument message_id"
      raise Exception.new, "Missing argument channel_id"

    end

    def perform(msg)
      message_id = msg[:message_id]
      channel_id = msg[:channel_id]

      begin
        message = Message.find(message_id)
        channel = Tgp::Push::Channel.find(channel_id)

        channel.devices.each do |device|
          device.push(message)
        end

      rescue => e
        puts "Tgp::Push::ChannelJob"
        puts e.backtrace
        # do nothing, maybe a log?
      end

    end
  end
end
