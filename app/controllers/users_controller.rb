class UsersController < ApplicationController
  before_filter :find_organization
  before_filter :require_user, :only => [:edit, :update, :destroy, :profile]
  before_filter :require_admin_organization_or_no_user, :only => [:new, :create]
  before_filter :require_organization_admin, :only => [:show, :toggle_admin ]
  before_filter :require_not_own_account, :only => [:toggle_admin]
  before_filter :require_own_or_organization_admin, :only => [:edit, :update, :destroy]
  before_filter :find_user, :only => [:edit, :update, :destroy ]
  layout nil
  
  # GET /users/new
  def new
    @user = @organization ? @organization.users.build : User.new
  end
  
  # GET /organizations/[organization_id]/users/1
  def show
    @user = User.find(params[:id])
  end
  
  # POST /users
  def create
    params[:user][:new_organization] = @organization if @organization
    @user = User.new(params[:user])
    if @user.save
      if @organization
        @user.new_organization = @organization
        render :json => { :id => @user.to_param, :organization => @organization.to_param}, :status => :created
      else
        flash[:notice] = "Welcome to the Agilar Taskboard!"
        redirect_back_or_default root_url
      end
    else
      if @organization
        render :json => @user.errors, :status => :precondition_failed
      else
        render :action => :new
      end
    end
  end
  
  # GET /users/1/edit
  def edit
  end
  
  # GET /users/profile
  def profile
    @user = current_user
    render :action => :edit
  end
  
  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      render :inline => "<script>top.Users.afterUpdate(#{{ :id => @user.id, :name => @user.name, :avatar => @user.avatar(:thumb), :is_current => @user == current_user }.to_json})</script>", :status => :ok
    else
      render :inline => "<script>top.ModalDialog.displayFormErrors(#{@user.errors.to_json})</script>", :status => :precondition_failed
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

  # POST /organizations/:organization_id/users/:user_id/toggle_admin
  def toggle_admin
    @user = User.find(params[:id])
    @om = @user.organization_memberships.first(:conditions => ['organization_id = ?', @organization.to_param])
    @om.admin = !@om.admin
    @om.save
    render :json => "", :status => :ok
  end
  
   
private
  def require_admin_organization_or_no_user
    @organization ? require_organization_admin : require_no_user
  end
  
  def require_own_account
    require_admin if params[:id] != current_user.to_param
  end

  def require_not_own_account
    deny_access if params[:id] == current_user.to_param
  end
  
  def require_own_or_organization_admin
    if params[:organization_id] 
      find_organization
      require_organization_admin if (params[:id] != current_user.to_param)
    else
      current_user.admin? if (params[:id] != current_user.to_param)
    end
  end
  
  def find_user
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = (@organization && current_user.admins?(@organization)) ? @organization.users.find(params[:id]) : @current_user
    end
  end
end