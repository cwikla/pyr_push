class UpdateUniqueIndexOnDevices < ActiveRecord::Migration
  def up
    remove_index :tgp_push_devices, :name => :dd_pd_idx
    remove_index :tgp_push_devices, :name => :tgppd_uddp_idx

    add_index :tgp_push_devices, [:user_id, :device_token, :device_type], :unique => true, :name => :tgp_pd_udd_idx
  end

  def down
    remove_index :tgp_push_devices, :name => :tgp_pd_udd_idx
  end
end
