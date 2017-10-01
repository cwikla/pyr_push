class MakeUserOkNull < ActiveRecord::Migration[5.1]
  def up
    change_column :pyr_push_devices, :user_id, :int, :null => true
  end

  def down
  end
end
