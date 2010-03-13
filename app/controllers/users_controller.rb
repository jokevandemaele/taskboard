class UsersController < ApplicationController
  before_filter :find_organization
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :require_admin_organization_or_no_user, :only => [:new, :create]
  before_filter :require_own_or_organization_admin, :only => [:destroy]
  before_filter :require_own_account, :only => [ :edit, :update]
  before_filter :find_user, :only => [ :edit, :update, :destroy]

  # Layout should be set to 'application' if the user is logged in and to 'user' if the user is logged out
  layout :set_layout
  
  # GET /users/new
  def new
    @user = @organization ? @organization.users.build : User.new
  end

  # POST /users
  def create
    params[:user][:new_organization] = @organization if @organization
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Welcome to the Agilar Taskboard!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  # GET /users/1/edit
  def edit
  end

  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      render :json => @user, :status => :ok
    else
      render :json => @user.errors, :status => :precondition_failed
    end
  end
  
  # DELETE /users/1
  def destroy
    # If the organization is not present, then we remove the user, but if it's present we only remove it from the organization.
    if !@organization && @user.destroy
      render :json => '', :status => :ok
    else
      @user.remove_from_organization(@organization)
      render :json => '', :status => :ok
    end
  end
  
   
private
  def set_layout
    current_user ? 'application' : nil
  end

  def require_admin_organization_or_no_user
    @organization ? require_organization_admin : require_no_user
  end
  
  def require_own_account
    require_admin if params[:id] != current_user.to_param
  end
  
  def require_own_or_organization_admin
    find_organization if params[:organization_id]
    return require_organization_admin if (@organization && @organization.users.include?(User.find(params[:id])))
    deny_access if (params[:id] != current_user.to_param)
  end
  
  def find_user
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = (@organization && current_user.admins?(@organization)) ? @organization.users.find(params[:id]) : @current_user
    end
  end
end