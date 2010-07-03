# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Uncomment this if you want to put the taskboard in maintenance mode.
  # before_filter :disable_taskboard
  
  helper :all # include all helpers, all the time
  helper_method :request_controller, :current_user_session, :current_user
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery :secret => '5e2fef265e68f375d5902befc545a584'
  protect_from_forgery :only => [:create, :update, :destroy] 
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :password_confirmation
  
  def request_controller
    request.path_parameters["controller"]
  end
  
  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to] = nil
      redirect_to(return_to)
    else                                                                                                                                                                                                                                         
      session[:return_to] = nil
      return redirect_to :controller => '/taskboard', :action => :show, :id => current_user.projects.first.id if current_user.projects.size == 1 && request.referer == url_for(:controller => 'admin/members', :action => :login, :only_path=>false)
      return redirect_to :controller => 'admin/projects', :action => 'index' if !current_user.admins_any_organization?
      redirect_to :controller => 'admin/organizations' if current_user.admins_any_organization?
    end
  end

  private
    def disable_taskboard
      # Create a better disabled page
      render :inline => "<center><img src=\"/images/login/login_logo.png\" alt=\"Agilar Taskboard\"/><br /><h1>Site under maintenance, plase come back later.</h1></center>"
      return false
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "Please Login"
        redirect_to login_path
        return false
      end
    end

    def require_admin
      deny_access unless current_user.admin?
    end

    def require_organization_admin
      param = (request_controller == 'organizations') ? params[:id] : params[:organization_id]
      return require_user if !current_user
      deny_access if !param || !current_user.admins?(Organization.find(param))
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "Please Logout"
        redirect_to account_url
        return false
      end
    end
    
    def require_belong_to_project_or_admin
      param = (request_controller == 'projects') ? params[:id] : params[:project_id]
      @project = @project || Project.find(param)
      params[:organization_id] = @project.organization.id
      require_organization_admin if !@project.users.include?(current_user)
    end
    
    def require_belong_to_team
      @team = Team.find(params[:team_id])
      require_admin if !@team.users.include?(current_user)
    end
    
    def store_location
      session[:return_to] = request.request_uri unless request.request_uri.match(/logout/)
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    # Find the organization from organization_id
    def find_organization
      @organization = Organization.find(params[:organization_id]) if params[:organization_id]
    end
    
    def find_story
      @story = @project.stories.find(params[:story_id])
    end
    
    def find_task
      @task = @story.tasks.find(params[:task_id])
    end
    
    def deny_access
      flash[:error] = "Access Denied"
      redirect_to root_url
      return false
    end

    def require_belong_to_project_or_auth_guest
      @project = Project.find(params[:project_id])
      @public_hash = params[:public_hash]
      if @project.public?
        require_belong_to_project_or_admin if @public_hash != @project.public_hash# check if has the correct hash
      else
        require_belong_to_project_or_admin
      end
    end

end
