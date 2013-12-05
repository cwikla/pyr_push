class CreateTgpPushDevices < ActiveRecord::Migration
  def change
    create_table :tgp_push_devices do |t|
      t.timestamps
      t.timestamp :deleted_at
      t.integer :user_id, :null => false
      t.string  :device, :null => false
      t.integer :device_type, :null => false
      t.boolean :is_active, :default => true, :null => false
    end

    add_index :tgp_push_devices, [:user_id, :device, :device_type], :name => :udd_idx, :unique => true
  end
end
