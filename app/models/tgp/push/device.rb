module Tgp
  module Push
    class Device < ActiveRecord::Base
      include Tgp::Push::Model::Device
    end
  end
end
