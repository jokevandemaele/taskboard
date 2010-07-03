class ProjectsController < ApplicationController
  before_filter :require_user
  before_filter :require_organization_admin, :only => [ :new , :create, :edit, :update, :destroy ]
  before_filter :find_organization, :only => [ :show, :new, :create, :edit, :update, :destroy]
  before_filter :require_belong_to_project_or_admin, :only => [:show]

  layout :application_unless_xhr
  # GET /organizations/[organization_id]/projects/new
  def new
    @project = @organization.projects.build()
  end
  
  # GET /organizations/[organization_id]/projects/1
  def show
    @project = @organization.projects.find(params[:id])
    if request.xhr?
      render :action => "show_ajax", :status => :ok
    end
  end
  
  # POST /organizations/[organization_id]/projects
  def create
    # REMEMBER: Add Team logic
    @project = @organization.projects.build(params[:project])
    if @project.save
      render :json => @project, :status => :created
    else
      render :json => @project.errors, :status => :precondition_failed
    end
  end
  
  # GET /organizations/[organization_id]/projects/1/edit
  def edit
    @project = @organization.projects.find(params[:id])
  end
  
  # PUT /organizations/[organization_id]/projects/1
  def update
    @project = @organization.projects.find(params[:id])
    if @project.update_attributes(params[:project])
      render :json => @project, :status => :ok
    else
      render :json => @project.errors, :status => :precondition_failed
    end
  end

  # DELETE /projects/1
  def destroy
    @project = @organization.projects.find(params[:id])
    if @project.destroy
      render :json => '', :status => :ok
    end
  end
  
  private
  def application_unless_xhr
    request.xhr? ? nil : 'application'
  end
end
