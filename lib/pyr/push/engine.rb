module Pyr
  module Push
    class Engine < ::Rails::Engine
      config.pyr_push_enabled = true
      config.pyr_push_apns_arn = nil
      config.pyr_push_gcm_arn = nil
      config.pyr_push_start_message_time = 900
      config.pyr_push_end_message_time = 2000
      config.pyr_push_ttl = 600 # 10 minutes
      config.pyr_push_sound = "default"
      config.pyr_push_db_logging_enabled = false
    end
  end
end
