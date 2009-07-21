class Admin::ProjectsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # GET /projects
  def index
    @member = current_member
    @admins = @member.admin?
    
    @projects = []
    if @member.admins_any_organization?
      @member.organizations_administered.each { |org| @projects.concat org.projects } 

      # Add the projects from the organizations it doesn't administers
      @member.projects.each { |proj| @projects << proj if(!@projects.include?(proj)) }
    else
      @projects = @member.projects
    end
  end

  # GET /projects/1
  def show
    @project = Project.find(params[:id])
  end

  # GET /projects/new
  def new
	  @project = Project.new
    @organization = (defined?(params[:organization])) ? params[:organization] : nil
    @free_projects = (defined?(params[:display_existing])) ? Project.free : @free_projects = nil
    
    render :partial => 'form', 
      :object => @project,
    	:locals => { 
    	  :edit => false, 
    	  :organization => @organization, 
    	  :free_projects => @free_project
    	}, :status => :ok
  end

  # GET /projects/1/edit
  def edit
	  @project = Project.find(params[:id])
    render :partial => 'form', :object => @project, :locals => { :edit => true, :organization => @organization, :free_projects => nil }
  end

  # POST /projects
  def create
    @project = Project.new(params[:project])

    if @project.save
      render :inline => "<script>location.reload(true);</script>", :status => :created
    else
      render :partial => 'form',
      		:object => @project,
      		:locals => { :no_refresh => true, :edit => false, :organization => @project.organization_id },
 		:status => :internal_server_error
    end
  end

  # PUT /projects/1
  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])
      render :inline => "<script>location.reload(true);</script>"
    else
      render :action => "edit"
    end
  end

  # DELETE /projects/1
  def destroy
    @project = Project.find(params[:id])
    # This is concateneted to [] to create a new array and not just reference it.
    @teams = [] + @project.teams
    if @project.destroy
      logger.error(@teams.inspect)
      @teams.each { |team| team.destroy }
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :internal_server_error
    end
  end
end
