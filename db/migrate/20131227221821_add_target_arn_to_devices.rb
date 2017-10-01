class AddTargetArnToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :pyr_push_devices, :target_arn, :string, :limit => 255
  end
end
