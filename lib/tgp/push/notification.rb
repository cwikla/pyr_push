require 'rapns'

module Tgp
  module Push
    class Notification

      def self.message(user_id, message, badge_count=nil, params={})
        user_id = user_id.is_a?(Integer) ? user_id : user_id.id

        count = 0

        devices = Tgp::Push::Device::where(:user_id => user_id, :is_active => true).each do |d|
          d.message(message, badge_count, params)
          count = count + 1
        end

        Rails.logger("User #{user_id} has no registered/active push devices!") if count == 0
      end

      def self.alert(user_id, the_message, params={})
        self.message(user_id, the_message, params[:badge_count], params)
      end

      def self.badge(user_id, count, params={})
        self.message(user_id, params[:alert] || params[:message], count, params)
      end

    end
  end
end
