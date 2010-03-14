ActionController::Routing::Routes.draw do |map|
  # Authlogic routes
  map.resource :user_sessions
  
  map.login '/login', :controller => "user_sessions", :action => "new" 
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"

  map.resources :users, :only => [ :new, :create, :edit, :update, :destroy ]
  map.resource :account, :controller => "users"

  map.resources :organizations do |o|
    o.resources :projects, :only => [ :new, :create, :edit, :update, :destroy] do |p|
      p.resources :guest_team_memberships, :only => [ :create, :destroy ] 
    end
    o.resources :guest_team_memberships, :only => [ :new ] 
    o.resources :teams, :only => [ :new, :create, :edit, :update, :destroy]
    o.resources :users, :only => [ :new, :create, :edit, :update, :destroy]
    o.user_toggle_admin 'users/:id/toggle_admin', :controller => 'users', :action => 'toggle_admin'
  end
  
  # Sample resource route within a namespace:
  map.namespace :admin do |admin|
   admin.resources :members
  end

  map.resources :project do |p|
    p.resources :taskboard, :only => [:index]
    p.resources :backlog, :only => [:index]
    p.resources :stories do |s|
     s.resources :tasks, :has_many => [:statustags, :nametags]
    end
  end

  # Dev Tools
  map.connect 'dev_tools/:action', :controller => 'dev_tools'

  # Named routes
  map.access_denied '/access_denied', :controller => 'admin/members', :action => "access_denied"
  map.report_bug '/report_bug', :controller => 'admin/members', :action => 'report_bug'
  map.invite '/invite', :controller => 'admin/members', :action => 'invite'

  # Root goes to admin/organizations
  map.root :controller => :account
  
  # Commented the default routes
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
