class CreateTgpPushChannelUsers < ActiveRecord::Migration
  def change
    create_table :tgp_push_channel_users do |t|
      t.timestamps

      t.integer :channel_id, :null => false
      t.integer :user_id, :null => false
    end

    add_index :tgp_push_channel_users, [:channel_id, :user_id], :unique => true
    add_index :tgp_push_channel_users, [:user_id]
  end
end
