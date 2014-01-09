class AddAppArnToTgpPushDevices < ActiveRecord::Migration
  def up
    remove_index :tgp_push_devices, :name => :udd_pd_idx

    add_column :tgp_push_devices, :platform_app_arn, :string, :limit => 64, :null => false, :default => "There ain't no ARN here"

    Tgp::Push::Device.all.each do |x|
      x.platform_app_arn = Tgp::Push::Engine.config.tgp_push_apns_arn if x.device_type == Tgp::Push::DEVICE_TYPE_IOS
      x.platform_app_arn = Tgp::Push::Engine.config.tgp_push_gcm_arn if x.device_type == Tgp::Push::DEVICE_TYPE_ANDROID
      x.save
    end

    add_index :tgp_push_devices, [:user_id, :device_token, :device_type, :platform_app_arn], :name => :tgppd_uddp_idx, :unique => true
  end

  def down
    remove_index :tgp_push_devices, :name => :tgppd_uddp_idx

    remove_column :tgp_push_devices, :platform_app_arn

    add_index :tgp_push_devices, [:user_id, :device_token, :device_token ], :name => :udd_pd_idx, :unique => true

  end
end
