class AddAppArnToPyrPushDevices < ActiveRecord::Migration
  def up
    remove_index :pyr_push_devices, :name => :udd_pd_idx

    add_column :pyr_push_devices, :platform_app_arn, :string, :limit => 64, :null => false, :default => "There ain't no ARN here"

    Pyr::Push::Device.all.each do |x|
      x.platform_app_arn = Pyr::Push::Engine.config.pyr_push_apns_arn if x.device_type == Pyr::Push::DEVICE_TYPE_IOS
      x.platform_app_arn = Pyr::Push::Engine.config.pyr_push_gcm_arn if x.device_type == Pyr::Push::DEVICE_TYPE_ANDROID
      x.save
    end

    add_index :pyr_push_devices, [:user_id, :device_token, :device_type, :platform_app_arn], :name => :pyrpd_uddp_idx, :unique => true
  end

  def down
    remove_index :pyr_push_devices, :name => :pyrpd_uddp_idx

    remove_column :pyr_push_devices, :platform_app_arn

    add_index :pyr_push_devices, [:user_id, :device_token, :device_token ], :name => :udd_pd_idx, :unique => true

  end
end
