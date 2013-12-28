class AddTargetArnToDevices < ActiveRecord::Migration
  def change
    add_column :tgp_push_devices, :target_arn, :string
  end
end
