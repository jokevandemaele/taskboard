# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5e2fef265e68f375d5902befc545a584'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def check_permissions
    @member = session[:member]
    # If user is sysadmin allow everything
    if @member.admin?
      return true
    end
    
    @path = request.path_parameters
    # Organizations controller can be accessible only if user is admin of that organization
    if @path[:controller] == "organizations"
      @organization = Organization.find(@path[:id])
      if @member.admins?(@organization)
        return true
      else
        redirect_to :controller => :members, :action => :access_denied
      end
    end

    # Taskboard and backlog can be accessible only if the member belogs to the project
    if ((@path[:controller] == "taskboard")||(@path[:controller] == "backlog"))
      @proj = Project.find(params[:id])
      logger.error(@proj.inspect)
      if !(@member.projects.include? @proj)
        redirect_to :controller => :members, :action => :access_denied
      end
    end
    
    # Manage Teams could only be accessed by organization admin
    if @path[:controller] == "teams"
      @proj = Project.find(params[:project])
      @organization = @proj.organization
      logger.error("Administra: ?",@member.admins?(@organization))
      if @member.admins?(@organization)
        return true
      else
        redirect_to :controller => :members, :action => :access_denied
      end
    end
    
    # Members could only be accessed by sysadmin
    if @path[:controller] == "members"
      redirect_to :controller => :members, :action => :access_denied
    end
    
  end
  
  def login_required
    if session[:member]
      return true
    end
      flash[:warning] = "Please login"
      session[:return_to] = request.request_uri
      redirect_to :controller => "members", :action => "login"
      return false
  end

  def current_member
    session[:member]
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to(return_to)
    else
      redirect_to :controller=>'projects', :action=>'index'
    end
  end

end
