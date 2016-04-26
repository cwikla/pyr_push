class CreatePyrPushDevices < ActiveRecord::Migration
  def change
    create_table :pyr_push_devices do |t|
      t.timestamps

      t.integer :user_id, :null => false
      t.string  :device_token, :limit => 64, :null => false
      t.integer :device_type,  :default => Pyr::Push::DEVICE_TYPE_IOS, :null => false
      t.boolean :is_active, :default => true, :null => false
    end

    add_index :pyr_push_devices, [:user_id, :device_token, :device_type], :name => :udd_pd_idx, :unique => true
    add_index :pyr_push_devices, [:device_token, :device_type], :name => :dd_pd_idx, :unique => true
  end
end
