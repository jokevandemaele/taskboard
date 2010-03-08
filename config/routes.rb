ActionController::Routing::Routes.draw do |map|
  # Authlogic routes
  map.resource :user_sessions
  
  map.login '/login', :controller => "user_sessions", :action => "new" 
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"

  map.resources :users
  map.resource :account, :controller => "users"

  # Sample resource route within a namespace:
  map.namespace :admin do |admin|
   admin.resources :organizations
   admin.resources :members
   admin.resources :teams
   admin.resources :projects
  end

  map.resources :statustags

  map.resources :nametags

  map.resources :tasks

  map.resources :stories
  
  map.resources :taskboard

  map.resources :backlog

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  map.connect 'dev_tools/:action', :controller => 'dev_tools'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.access_denied '/access_denied', :controller => 'admin/members', :action => "access_denied"
  map.report_bug '/report_bug', :controller => 'admin/members', :action => 'report_bug'
  map.report_bug '/invite', :controller => 'admin/members', :action => 'invite'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "admin/organizations"
  
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
