class FixUniqueIndexii < ActiveRecord::Migration[5.1]
  def up
    remove_index :pyr_push_devices, :name => :pyrpd_uddp_idx
    add_index :pyr_push_devices, [:device_token, :device_type, :platform_app_arn], :name => :pyrpd_uddp_idx, :unique => true
  end

  def down
    # nothing to see here
  end
end
