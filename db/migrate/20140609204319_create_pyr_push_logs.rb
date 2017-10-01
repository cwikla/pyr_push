class CreatePyrPushLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :pyr_push_logs do |t|
      t.integer :device_id, :null => false
      t.text :package, :limit => 4096, :null => false

      t.timestamps
    end
  end
end
