class OrganizationsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin, :only => [ :new, :create, :add_user ]
  before_filter :require_organization_admin, :only => [:show, :edit, :update, :destroy ]
  before_filter :find_organization, :only => [:edit, :update, :destroy, :add_user ]
  layout "application", :only => [ :index ]
  
  # GET /organizations
  def index
    @organizations = (current_user.admin?) ? Organization.all : current_user.organizations
  end

  # GET /organizations/1
  def show
    @organization = Organization.find(params[:id])
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    render :action => :new
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      render :json => @organization, :status => :created
    else
      render :json => @organization.errors, :status => :precondition_failed
    end
  end
  
  # GET /organizations/1/edit
  def edit 
    render :action => :edit
  end

  # PUT /organizations/1
  def update
    if @organization.update_attributes(params[:organization])
      render :json => @organization, :status => :ok
    else
      render :json => @organization.errors, :status => :precondition_failed
    end
  end
  
  # DELETE /organizations/1
  def destroy
    if @organization.destroy
      render :json => '', :status => :ok
    end
  end
  
  def add_user
    @user = User.find(params[:user_id])
    @organization.users << @user
    render :json => { :id => @user.to_param, :organization => @organization.to_param}, :status => :ok
  end
  
  def find_organization
    @organization = Organization.find(params[:id])
  end
end
