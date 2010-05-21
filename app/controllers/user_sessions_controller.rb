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
      redirect_back_or_default organizations_url
    else
      deny_access
    end
  end
  
  def destroy
    current_user_session.destroy
    redirect_back_or_default login_path
  end
end
