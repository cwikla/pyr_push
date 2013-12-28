module Tgp
  module Push
    class Channel < ActiveRecord::Base
      include Tgp::Push::Model::Channel
    end
  end
end
