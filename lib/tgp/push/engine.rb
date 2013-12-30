module Tgp
  module Push
    class Engine < ::Rails::Engine
      config.tgp_push_apns_arn = nil
      config.tgp_push_gcm_arn = nil
      config.tgp_push_default_start_message_time = 0
      config.tgp_push_default_end_message_time = 2400
    end
  end
end
