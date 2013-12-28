class CreateTgpPushChannelNotifications < ActiveRecord::Migration
  def change
    # copies from Rapns gem

    create_table :tgp_push_channel_notifications do |t|
      t.timestamps
      t.string    :sound,                 :null => true,  :default => "1.aiff" 
      t.string    :alert,                 :null => true
      t.integer   :expiry,                :null => false, :default => 1.day.to_i
      t.timestamp :deliver_after,         :null => true
      t.boolean   :alert_is_json,         :null => false, :default => false
      t.timestamp :delivered_at
    end

    add_index :tgp_push_channel_notifications, [:delivered_at, :deliver_after, :expiry], :name => :tgp_dde_idx
  end
end
