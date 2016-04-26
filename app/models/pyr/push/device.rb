module Pyr
  module Push
    class Device < ActiveRecord::Base
      include Pyr::Push::Model::Device
    end
  end
end
