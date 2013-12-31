module Tgp
  module Push
    class ChannelNotification < ActiveRecord::Base
      include Tgp::Push::Model::ChannelNotification
    end
  end
end
