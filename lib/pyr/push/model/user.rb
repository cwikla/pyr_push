module Pyr
  module Push
    module Model
      module User
        extend ActiveSupport::Concern

        included do
          has_many :devices, :class_name => "Pyr::Push::Device"
          has_many :active_devices, :class_name => "Pyr::Push::Device", :conditions => proc { "is_active = true and device_token is not null and device_type is not null" }
        end

        def can_push?
          return !self.active_devices.blank?
        end
      end
    end
  end
end
