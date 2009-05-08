class ProjectsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions, :except => [:index]
  
  # GET /projects
  def index
    @projects = current_member.projects
    @member = current_member
    @admins = @member.admin?
    if @projects.length == 1
      redirect_to :controller => :taskboard, :action => :show, :id => @projects.first.id
    end
  end

  # GET /projects/1
  def show
    redirect_to(:controller => :taskboard, :action => :show, :id => params[:id])
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
    @project.organization_id = nil
    if @project.save
      flash[:notice] = 'Project was successfully created.'
      redirect_to(organizations_path)
    else
      render :action => "new"
    end
  end

  # PUT /projects/1
  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])
      flash[:notice] = 'Project was successfully updated.'
      redirect_to(@project)
    else
      render :action => "edit"
    end
  end

  # DELETE /projects/1
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to(projects_url)
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
