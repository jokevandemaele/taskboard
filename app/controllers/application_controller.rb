# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Use the ExepctionNotifiable plugin to send a mail when an error is thrown.
  include ExceptionNotifiable
  ExceptionNotifier.exception_recipients = %w(taskboard@agilar.org)
  ExceptionNotifier.sender_address = %("Taskboard Error" <taskboard-error@agilar.com>)
  ExceptionNotifier.email_prefix = "[TASKBOARD-ERROR] "
  ExceptionNotifier.smtp_settings = {  :address => "mail.agilar.org",  :port => 25,  :domain => "agilar.org" } 
  
  helper :all # include all helpers, all the time
  helper_method :request_controller
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5e2fef265e68f375d5902befc545a584'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def check_permissions
    @member = Member.find(session[:member])
    # If user is sysadmin allow everything
    if @member.admin?
      return true
    end
    
    @path = request.path_parameters
    # Organizations controller can be accessible only if user is admin of that organization
    if @path[:controller] == "organizations"
      # This is needed because show_form recieves the organization as :organization not as :id, change that.
      if defined?(params[:organization][:id])
        id = params[:organization][:id]
      else
        id = @path[:id]
      end
      
      @organization = Organization.find(id)
      if @member.admins?(@organization)
        return true
      else
        redirect_to :controller => :members, :action => :access_denied
      end
    end

    # Taskboard and backlog can be accessible only if the member belogs to the project and by organization admin
    if ((@path[:controller] == "taskboard")||(@path[:controller] == "backlog"))
      @proj = Project.find(params[:id])
      if (@member.admins?(@proj.organization))
        return true
      end
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
    
    # Members could only be accessed by sysadmin or if the user is the admin of the organization
    if @path[:controller] == "members"
      if params[:project]
        project = Project.find(params[:project])
      else
        project = Project.new
      end 

      if params[:project] && @member.admins?(project.organization)
        return true
      end
      if @member.id == params[:id]
        return true
      end
      redirect_to :controller => :members, :action => :access_denied
    end
  end
  
  def login_required
    #render :inline => "<center><img src=\"http://localhost:3000/images/login/login_logo.png\" alt=\"Agilar Taskboard\"/><br /><h1>Site under maintenance, plase come back later.</h1></center>"
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
      session[:return_to]=nil
      redirect_to(return_to)
    else
      redirect_to :controller=>'projects', :action=>'index'
    end
  end

end
