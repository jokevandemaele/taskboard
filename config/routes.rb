ActionController::Routing::Routes.draw do |map|
  # Authlogic routes
  map.resource :user_sessions
  
  map.login '/login', :controller => "user_sessions", :action => "new" 
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"

  map.resources :users, :only => [ :new, :create, :edit, :update, :destroy ]
  map.resource :account, :controller => "users"

  map.resources :organizations do |o|
    o.resources :projects, :only => [ :show, :new, :create, :edit, :update, :destroy]
    # o.resources :guest_team_memberships, :only => [ :new ] 
    o.resources :teams, :only => [ :show, :new, :create, :edit, :update, :destroy] 
    o.team_add_users 'teams/:id/users/:user_id', :controller => 'teams', :action => :add_user, :conditions => { :method => :post }
    o.team_remove_users 'teams/:id/users/:user_id', :controller => 'teams', :action => :remove_user, :conditions => { :method => :delete }
    o.team_info 'teams/:id/team_info', :controller => 'teams', :action => :team_info, :conditions => { :method => :get }

    o.user_toggle_admin 'users/profile', :controller => 'users', :action => 'edit_profile', :conditions => { :method => :get }
    o.resources :users, :only => [ :show, :new, :create, :edit, :update, :destroy]
    o.user_toggle_admin 'users/:id/toggle_admin', :controller => 'users', :action => 'toggle_admin', :conditions => { :method => :post }
  end
  map.add_user_to_organization 'organizations/:id/add_user', :controller => :organizations, :action => :add_user, :conditions => {:method => :post}
  
  # Sample resource route within a namespace:
  map.namespace :admin do |admin|
   admin.resources :members
  end

  map.resources :projects, :only => [] do |p|
    p.resources :taskboard, :only => [:index]
    p.resources :backlog, :only => [:index]
    p.resources :stories do |s|
     s.resources :tasks, :has_many => [ :statustags, :nametags ]
     s.task_start 'tasks/:id/start', :controller => :tasks, :action => :start, :conditions => { :method => :post }
     s.task_stop 'tasks/:id/stop', :controller => :tasks, :action => :stop, :conditions => { :method => :post }
     s.task_finish 'tasks/:id/finish', :controller => :tasks, :action => :finish, :conditions => { :method => :post }
     s.task_update_name 'tasks/:id/update_name', :controller => :tasks, :action => :update_name, :conditions => { :method => :post }
     s.task_update_description 'tasks/:id/update_description', :controller => :tasks, :action => :update_description, :conditions => { :method => :post }
     s.task_update_color 'tasks/:id/update_color', :controller => :tasks, :action => :update_color, :conditions => { :method => :post }
    end
    p.story_start 'stories/:id/start', :controller => :stories, :action => :start, :conditions => { :method => :post }
    p.story_stop 'stories/:id/stop', :controller => :stories, :action => :stop, :conditions => { :method => :post }
    p.story_finish 'stories/:id/finish', :controller => :stories, :action => :finish, :conditions => { :method => :post }
    p.story_update_priority 'stories/:id/update_priority', :controller => :stories, :action => :update_priority, :conditions => { :method => :post }
    p.story_update_size 'stories/:id/update_size', :controller => :stories, :action => :update_size, :conditions => { :method => :post }
  end
  
  map.resources :teams, :only => [], :has_many => :stories
  map.taskboard_team_view 'teams/:team_id/taskboard', :controller => :taskboard, :action => :team
  map.backlog_team_view 'teams/:team_id/backlog', :controller => :backlog, :action => :team
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
