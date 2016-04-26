class CreatePyrPushChannels < ActiveRecord::Migration
  def change
    create_table :pyr_push_channels do |t|
      t.timestamps
      t.timestamp :deleted_at
      t.string :name, :null => false
    end

    add_index :pyr_push_channels, [:name], :unique => true
  end
end
