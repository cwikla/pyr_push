class UpdateUniqueIndexOnDevices < ActiveRecord::Migration[5.1]
  def up
    remove_index :pyr_push_devices, :name => :dd_pd_idx
    remove_index :pyr_push_devices, :name => :pyrpd_uddp_idx

    add_index :pyr_push_devices, [:user_id, :device_token, :device_type], :unique => true, :name => :pyr_pd_udd_idx
  end

  def down
    remove_index :pyr_push_devices, :name => :pyr_pd_udd_idx
  end
end
