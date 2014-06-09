module Tgp
  module Push
    class Engine < ::Rails::Engine
      config.tgp_push_enabled = true
      config.tgp_push_apns_arn = nil
      config.tgp_push_gcm_arn = nil
      config.tgp_push_start_message_time = 900
      config.tgp_push_end_message_time = 2000
      config.tgp_push_ttl = 600 # 10 minutes
      config.tgp_push_sound = "default"
      config.tgp_push_db_logging_enabled = false
    end
  end
end
