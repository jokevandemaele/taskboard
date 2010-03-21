ActionController::Routing::Routes.draw do |map|
  # Authlogic routes
  map.resource :user_sessions
  
  map.login '/login', :controller => "user_sessions", :action => "new" 
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"

  map.resources :users, :only => [ :new, :create, :edit, :update, :destroy ]
  map.resource :account, :controller => "users"

  map.resources :organizations do |o|
    o.resources :projects, :only => [ :show, :new, :create, :edit, :update, :destroy] do |p|
      # p.resources :guest_team_memberships, :only => [ :create, :destroy ] 
    end
    # o.resources :guest_team_memberships, :only => [ :new ] 
    o.resources :teams, :only => [ :show, :new, :create, :edit, :update, :destroy] 
    o.team_add_users 'teams/:id/users/:user_id', :controller => 'teams', :action => :add_user, :conditions => { :method => :post }
    o.team_remove_users 'teams/:id/users/:user_id', :controller => 'teams', :action => :remove_user, :conditions => { :method => :delete }
    o.team_info 'teams/:id/team_info', :controller => 'teams', :action => :team_info, :conditions => { :method => :get }

    o.resources :users, :only => [ :show, :new, :create, :edit, :update, :destroy]
    o.user_toggle_admin 'users/:id/toggle_admin', :controller => 'users', :action => 'toggle_admin', :conditions => { :method => :post }
  end
  
  # Sample resource route within a namespace:
  map.namespace :admin do |admin|
   admin.resources :members
  end

  map.resources :projects, :only => [] do |p|
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
  map.root :controller => :organizations
  
  # Commented the default routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
