module Pyr
  module Push
    class ChannelUser < ActiveRecord::Base
      include Pyr::Push::Model::ChannelUser
    end
  end
end
