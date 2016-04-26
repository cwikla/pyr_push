module Pyr
  module Push
    module Model
      module Log
        extend ActiveSupport::Concern
      
        included do
          self.table_name = 'pyr_push_logs'


          attr_accessible :device_id, 
                          :package
        end

      end
    end
  end
end
