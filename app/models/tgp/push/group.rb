module Tgp
  module Push
    class Group < ActiveRecord::Base
      set_table_name "tgp_push_groups"

      acts_as_paranoid

      attr_accessible :user_id,
                      :name

      belongs_to :user
    end
  end
end
