Hoshinplan::Application.routes.draw do
  get ENV['RAILS_RELATIVE_URL_ROOT'] => 'front#index' if ENV['RAILS_RELATIVE_URL_ROOT']

  root :to => 'front#index'

  get 'users/:id/reset_password_from_email/:key' => 'users#reset_password', :as => 'reset_password_from_email'

  get 'users/:id/accept_invitation_from_email/:key' => 'users#accept_invitation', :as => 'accept_invitation_from_email'

  get 'users/:id/activate_from_email/:key' => 'users#activate', :as => 'activate_from_email'
  
  get 'user_companies/:id/accept_from_email/:key' => 'user_companies#accept', :as => 'accept_from_email'

  get 'search' => 'front#search', :as => 'site_search'
  
  get 'first' => 'front#first', :as => 'front_first'

  get 'about' => 'cms#page', :as => 'cms_about', :key => :about

  get 'features' => 'cms#page', :as => 'cms_features', :key => :features

  get 'pricing' => 'cms#page', :as => 'cms_pricing', :key => :pricing

  get 'invitation-accepted' => 'front#invitation_accepted', :as => 'front_invitation_accepted'

  get 'reprocessphotos' => 'front#reprocess_photos', :as => 'reprocess_photos'
  
  get 'sendreminders' => 'front#sendreminders', :as => 'send_reminders'
  
  get 'updateindicators' => 'front#updateindicators', :as => 'update_indicators'
  
  get 'expirecaches' => 'front#expirecaches', :as => 'expire_caches'

  get 'resetcounters' => 'front#resetcounters', :as => 'reset_counters'

  get 'healthupdate' => 'front#healthupdate', :as => 'health_update'

  get 'colorize' => 'front#colorize', :as => 'colorize'

  get 'mail_preview' => 'mail_preview#index'
  
  get 'mail_preview(/:action(/:id(.:format)))' => 'mail_preview#:action'
  
  get  'admin' => 'admin/admin_site#index'
  
  get  'cms/:key/expire' => 'cms#expire', :constraints => {:key => /.*/}
  
  get  'cms/:key' => 'cms#show', :constraints => {:key => /.*/}
  
  get  'users/logout_and_return' => 'users#logout_and_return', :as => 'logout_and_return'
  
  get  'oid_login' => 'front#oid_login', :as => 'oid_login'
  
  get "/auth/failure" => "front#failure"
  
  post "/tasks/form" => "tasks#form", :as => 'task_form'

  post "/indicators/form" => "indicators#form", :as => 'indicators_form'
  
  get "/pitch" => "front#pitch"
  
  #post "/auth/:provider/callback" => "users#omniauth_callback"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  get '/404' => 'errors#not_found'
  get '/422' => 'errors#server_error'
  get '/500' => 'errors#server_error'
end
