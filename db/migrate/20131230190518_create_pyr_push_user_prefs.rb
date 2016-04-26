class CreatePyrPushUserPrefs < ActiveRecord::Migration
  def change
    create_table :pyr_push_user_prefs do |t|
      t.timestamps
      t.integer :user_id, :null => false
      t.string :tz
      t.integer :start_time # 800 = 8am, 830 = 830
      t.integer :end_time # same thing
    end

    add_index :pyr_push_user_prefs, [:user_id], :unique => true
  end
end
