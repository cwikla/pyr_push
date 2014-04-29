class FixUniqueIndexii < ActiveRecord::Migration
  def up
    remove_index :tgp_push_devices, :name => :tgppd_uddp_idx
    add_index :tgp_push_devices, [:device_token, :device_type, :platform_app_arn], :name => :tgppd_uddp_idx, :unique => true
  end

  def down
    # nothing to see here
  end
end
