ActionController::Routing::Routes.draw do |map|
  # Sample resource route within a namespace:
  map.namespace :admin do |admin|
   admin.resources :organizations
  end

  map.resources :rights

  # map.resources :organizations

  map.resources :roles

  map.resources :members

  map.resources :teams

  map.resources :statustags

  map.resources :nametags

  map.resources :projects

  map.resources :tasks

  map.resources :stories
  
  map.resources :taskboard

  map.resources :backlog
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.login '/login', :controller => 'members', :action => 'login'
  map.logout '/logout', :controller => 'members', :action => 'logout'
  map.access_denied '/access_denied', :controller => 'members', :action => "access_denied"
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "projects"
  
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
