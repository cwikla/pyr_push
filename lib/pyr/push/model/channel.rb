module Tgp
  module Push
    module Model
      class NoSuchChannelException < Exception
      end

      module Channel
        extend ActiveSupport::Concern
      
        included do
          self.table_name = "tgp_push_channels"

          attr_accessible :name
       
          has_many :channel_users
          has_many :users, through: :channel_users
        end
      
        module ClassMethods
          def subscribe(user_or_id, channel_name, only_if_exists=false)
            channel_name = channel_name.to_s

            channel = nil
            if only_if_exists
              channel = where(name: channel_name).first
              raise NoSuchChannelException, channel_name
            else
              channel = find_or_create_unique(name: channel_name) # see if channel exists, if not
            end

            user_id = user_or_id.is_a?(Integer) ? user_or_id : user_or_id.id

            channel.channel_users.find_or_create_unique(:channel_id => channel.id, :user_id => user_or_id)
          
            channel.save

          end

          def unsubscribe(user_or_id)
            user_id = user_or_id.is_a?(Integer) ? user_or_id : user_or_id.id

            self.users.where(user_id: user_id).destroy
          end

          def each(channel_name, &block)
            channel = self.where(:name => channel_name).first
            return if channel.nil?

            channel.channel_users.where(:channel_id => channel.id).find_in_batches do |batch|
              batch.each do |cu|
                yield cu.user_id
              end
            end
          end


          def list(user_or_id)
            user_id = user_or_id.is_a?(Integer) ? user_or_id : user_or_id.id

            self.where(user_id: user_id).all
          end
        end

      end
    end
  end
end
