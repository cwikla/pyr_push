module Pyr
  module Push
    module Model
      module ChannelUser
        extend ActiveSupport::Concern
      
        included do
          self.table_name = "pyr_push_channel_users"

          attr_accessible :channel_id,
                          :user_id

          belongs_to :channel
          belongs_to :user

          validate :channel, :presence => true
          validate :user, :presence => true
        end
      
        module ClassMethods
        end

      end
    end
  end
end
