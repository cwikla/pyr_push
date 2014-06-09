module Tgp
  module Push
    class Log < ActiveRecord::Base
      include Tgp::Push::Model::Log
    end
  end
end

