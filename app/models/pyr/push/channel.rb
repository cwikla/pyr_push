module Pyr
  module Push
    class Channel < ActiveRecord::Base
      include Pyr::Push::Model::Channel
    end
  end
end
