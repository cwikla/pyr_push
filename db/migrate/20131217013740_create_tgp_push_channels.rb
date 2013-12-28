class CreateTgpPushChannels < ActiveRecord::Migration
  def change
    create_table :tgp_push_channels do |t|
      t.timestamps
      t.timestamp :deleted_at
      t.string :name, :null => false
    end

    add_index :tgp_push_channels, [:name], :unique => true
  end
end
