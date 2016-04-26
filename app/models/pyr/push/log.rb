module Pyr
  module Push
    class Log < ActiveRecord::Base
      include Pyr::Push::Model::Log
    end
  end
end

