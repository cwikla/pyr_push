module Tgp
  module Push
    module Model
      module User
        extend ActiveSupport::Concern
      
        included do
          has_many :push_devices, :class_name => "Tgp::Push::Device"
          has_many :push_groups,  :class_name => "Tgp::Push::Group"
        end
      
        module ClassMethods
        end

        def push_add_device(device, device_type)
          d = find_or_create_unique(device: device, device_type: device_type, user_id: self.id)
          d.is_active = true
          d.save
        end

        def push_remove_device(device, device_type)
          d = where(device: device, device_type: device_type, user_id: self.id).first
          if d
            d.is_active = false
            d.save
          end
        end

        def push_add_to_group(name)
          d = find_or_create_unique(user_id: self.id, name: name)
          d.is_active = true
          d.save
        end

        def push_remove_from_group(name)
          d = where(user_id: self.id, name: name).first
          if d
            d.is_active = false
            d.save
          end
        end
      end
    end
  end
end
