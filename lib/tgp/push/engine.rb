module Tgp
  module Push
    class Engine < ::Rails::Engine
      config.tgp_push_apns_arn = nil
      config.tgp_push_gcm_arn = nil
    end
  end
end
