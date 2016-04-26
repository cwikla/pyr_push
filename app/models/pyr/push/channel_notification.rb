module Pyr
  module Push
    class ChannelNotification < ActiveRecord::Base
      include Pyr::Push::Model::ChannelNotification
    end
  end
end
