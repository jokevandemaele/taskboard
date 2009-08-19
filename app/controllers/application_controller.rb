# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Use the ExepctionNotifiable plugin to send a mail when an error is thrown.

  helper :all # include all helpers, all the time
  helper_method :request_controller, :current_member
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5e2fef265e68f375d5902befc545a584'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def check_permissions
    @current_member = current_member
    
    # If user is sysadmin allow everything
    return true if @current_member.admin?
    
    # If user is not a sysadmin, permissions should be applied
    @path = request.path_parameters
    case @path['controller']
      when 'admin/organizations'
        result = check_organizations_controller_perms(@current_member, @path, request)
      when 'admin/members'
        result = check_members_controller_perms(@current_member, @path, request)
      when 'admin/projects'
        result = check_projects_controller_perms(@current_member, @path, request)
      when 'admin/teams'
        result = check_teams_controller_perms(@current_member, @path, request)
      when 'taskboard'
        result = check_taskboard_perms(@current_member, @path, request)
      when 'backlog'
        result = check_backlog_perms(@current_member, @path, request)
      else
        return true
    end
    return true if result
    redirect_to :controller => 'admin/members', :action => :access_denied
  end
  
  def check_taskboard_perms(member, path, request)
    # Taskboard and backlog can be accessible only if the member belogs to the project or if it admins the project organization
    @proj = Project.find(params[:id])
    return (@current_member.admins?(@proj.organization) || @current_member.projects.include?(@proj))
  end
  
  def check_backlog_perms(member, path, request)
    check_taskboard_perms(member, path, request)
  end
  
  def check_organizations_controller_perms(member, path, request)
    return session[:member] != nil if path['action'] == 'index'
    return @current_member.admin? if path['action'] == 'new'
    return @current_member.admin? if path['action'] == 'create'
    return @current_member.admins?(Organization.find(params[:id]))
  end

  def check_members_controller_perms(member, path, request)
    # Bug Report Should be accessible if logged in
    return session[:member] != nil if path['action'] == 'bug_report'

    return member.admin? if path['action'] == 'index'

    if path['action'] == 'edit' or path['action'] == 'update'
      return true if (@current_member.id == request.params[:id].to_i)
      memberships = OrganizationMembership.find_all_by_member_id(request.params[:id])
      result = false
      memberships.each do |membership|
        result = result || member.admins?(membership.organization)
      end
      return result
    end
    
    # A user can always edit and update itself
    return member.admins?(Organization.find(request.params[:organization]))
    return false
  end

  def check_projects_controller_perms(member, path, request)
    return session[:member] != nil if path['action'] == 'index'

    if path['action'] == 'new'
      return member.admins?(Organization.find(request.params[:organization])) if (request.params[:organization])
      return member.admins_any_organization?
    end
    
    return member.admins?(Organization.find(request.params[:project][:organization_id])) if path['action'] == 'create'
    return member.admins?(Project.find(params[:id]).organization)
  end

  def check_teams_controller_perms(member, path, request)
    return true if path['action'] == 'display_compact_info'
    
    if path['action'] == 'index'
      return member.admins?(Project.find(params[:project]).organization) if(params[:project])
      return member.admins_any_organization?
    end
        
    if path['action'] == 'add_member' || path['action'] == 'remove_member'
      check_member = Member.find(params[:member])
      check_team = Team.find(params[:team])
      result = false
      check_team.projects.each do |project|
        result = result || member.admins?(project.organization) if(check_member.organizations.include?(project.organization))
      end
      return result
    end
    return @current_member.admins?(Organization.find(params[:organization])) if path['action'] == 'new'
    return @current_member.admins?(Organization.find(params[:team][:organization_id])) if path['action'] == 'create' || path['action'] == 'update'
    team = Team.find(params[:id])
    return @current_member.admins?(team.organization)
  end
  
  def login_required
    #render :inline => "<center><img src=\"/images/login/login_logo.png\" alt=\"Agilar Taskboard\"/><br /><h1>Site under maintenance, plase come back later.</h1></center>"
    #return false
    
    if session[:member]
      return true
    end
      session[:return_to] = request.request_uri
      redirect_to :controller => "admin/members", :action => "login"
      return false
  end

  def current_member
    Member.find(session[:member])
  end

  def request_controller
    request.path_parameters[:controller]
  end
  
  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to] = nil
      redirect_to(return_to)
    else                                                                                                                                                                                                                                         
      return redirect_to :controller => 'admin/organizations' if current_member.admins_any_organization?
      return redirect_to :controller => '/taskboard', :action => :show, :id => current_member.projects.first.id if current_member.projects.size == 1 && request.referer == url_for(:controller => 'admin/members', :action => :login, :only_path=>false)
      redirect_to :controller => 'admin/projects', :action => 'index'
    end
  end

end
