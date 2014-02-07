Rails.application.routes.draw do
  match '/push_notifications/:id(.:format)' => "tgp/push/push_notifications#create", :via => :post
  match '/push_notifications/:id(.:format)' => "tgp/push/push_notifications#destroy", :via => :delete
  match '/push_notifications(.:format)' => "tgp/push/push_notifications#create", :via => :post
  match '/push_notifications(.:format)' => "tgp/push/push_notifications#destroy", :via => :delete
end
