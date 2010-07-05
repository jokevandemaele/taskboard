class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  layout nil
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash = {}
      flash[:notice] = "Login successful!"
      default_url = (@user_session.user.projects.count == 1 && !@user_session.user.admins_any_organization?) ? project_taskboard_index_url(@user_session.user.projects.first.to_param) : root_url
      redirect_back_or_default default_url
    else
      deny_access
    end
  end
  
  def destroy
    current_user_session.destroy
    redirect_back_or_default login_path
  end
end
