module Tgp
  module Push
    class ChannelUser < ActiveRecord::Base
      include Tgp::Push::Model::ChannelUser
    end
  end
end
