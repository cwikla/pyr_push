module Tgp
  module Push
    class UserPref < ActiveRecord::Base
      include Tgp::Push::Model::UserPref
    end
  end
end

