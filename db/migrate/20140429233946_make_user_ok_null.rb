class MakeUserOkNull < ActiveRecord::Migration
  def up
    change_column :tgp_push_devices, :user_id, :int, :null => true
  end

  def down
  end
end
