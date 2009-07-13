class Admin::ProjectsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions, :except => [:index]
  
  # GET /projects
  def index
    @member = current_member
    @admins = @member.admin?
    
    @projects = []
    if @member.admins_any_organization?
      @member.organizations_administered.each { |o| @projects.concat o.projects } 
    else
      @projects = @member.projects
      redirect_to :controller => :taskboard, :action => :show, :id => @projects.first.id if @projects.length == 1
    end
    
  end

  # GET /projects/1
  def show
    @project = Project.find(params[:id])
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  def create
    @project = Project.new(params[:project])

    if @project.save
      render :inline => "<script>location.reload(true);</script>"
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
    if @project.destroy
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :internal_server_error
    end
  end
  
  def show_form
    @edit = false
    if(params[:id])
	    @project = Project.find(params[:id])
	    @edit = true
    else
	    @project = Project.new
    end
    
    if defined? params[:organization]
      @organization = params[:organization]
    else
      @organization = nil
    end
    
    if defined? params[:display_existing]
      @free_projects = Project.free
    else
      @free_projects = nil
    end
    
    render :update do |page|
    		page.replace_html "dummy-for-actions", 
    		:partial => 'form',
    		:object => @project,
    		:locals => { :edit => @edit, :organization => @organization, :free_projects => @free_projects }
    end
  end
  
  def add_team_to_project
    @project = Project.find(params[:id])
    @teams = Team.find(:all).collect { |team| [team.name, team.id] }
  end

  def create_team_to_project_relation
    @project = Project.find(params[:id])
    @team = Team.find(params[:team_id])
    if !@project.teams.exists?(@team)
      @project.teams << @team
      @project.save
    end
    redirect_to(projects_url)
  end

  def delete_team_to_project_relation
    @project = Project.find(params[:id])
    @team = Team.find(params[:team_id])
    if @project.teams.exists?(@team)
      @project.teams.delete(@team)
      @project.save
    end
    redirect_to(projects_url)
  end
end
