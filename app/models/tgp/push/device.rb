module Tgp
  module Push
    class Device < ActiveRecord::Base
      acts_as_paranoid

      set_table_name "tgp_push_devices"

      attr_accessible :user_id,
                      :device,
                      :device_type,
                      :is_active

      belongs_to :user
    end
  end
end
