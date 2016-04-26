module Pyr
  module Push
    class UserPref < ActiveRecord::Base
      include Pyr::Push::Model::UserPref
    end
  end
end

