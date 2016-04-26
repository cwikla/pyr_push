module Tgp
  module Push
    module Model
      module ChannelNotification
        extend ActiveSupport::Concern
      
        included do
          self.table_name = "tgp_push_channel_notifications"

          attr_accessible :channel_id,
            :sound,
            :alert,
            :expiry,
            :deliver_after,
            :alert_is_json

          belongs_to :channel
        end
      
        module ClassMethods
        end

      end
    end
  end
end
