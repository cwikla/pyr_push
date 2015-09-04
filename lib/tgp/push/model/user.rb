module Tgp
  module Push
    module Model
      module User
        extend ActiveSupport::Concern

        def can_push?
          return self.device && self.device.is_active? && !self.device.device_token.nil? && !self.device_type.nil?
        end
      end
    end
  end
end
