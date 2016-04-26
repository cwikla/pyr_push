class CreatePyrPushChannelUsers < ActiveRecord::Migration
  def change
    create_table :pyr_push_channel_users do |t|
      t.timestamps

      t.integer :channel_id, :null => false
      t.integer :user_id, :null => false
    end

    add_index :pyr_push_channel_users, [:channel_id, :user_id], :unique => true
    add_index :pyr_push_channel_users, [:user_id]
  end
end
