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
    @teams = @organization ? Team.all(:conditions => [ "organization_id = ? ", @organization ]) : []
    @selected = ''
    render :partial => 'form', 
      :object => @project,
    	:locals => { 
    	  :edit => false, 
    	  :organization => @organization, 
    	  :teams => @teams,
    	  :free_projects => @free_project
    	}, :status => :ok
  end

  # GET /projects/1/edit
  def edit
	  @project = Project.find(params[:id])
    @organization = @project.organization_id
    @teams = @organization ? Team.all(:conditions => [ "organization_id = ? ", @organization ]) : nil
    @selected = (@project.teams.empty?) ? nil : @project.teams.first.id
    render :partial => 'form', :object => @project, :locals => { :edit => true, :free_projects => nil }
  end

  # POST /projects
  def create
    @project = Project.new(params[:project])

    if @project.save
      if(params[:create_team])
        @team = Team.new
        @organization = @project.organization
        render :partial => 'admin/teams/form', :locals => { :edit => false, :organization =>  @organization, :project => @project }, :status => :ok
      else
        @project.teams << Team.find(params[:team_id])
        render :inline => "<script>location.reload(true);</script>", :status => :created
      end
    else
      @teams = Team.all(:conditions => [ "organization_id = ? ", @project.organization.id ])
      render :partial => 'form',
      		:object => @project,
      		:locals => { :no_refresh => true, :edit => false, :organization => @project.organization },
 		:status => :internal_server_error
    end
  end

  # PUT /projects/1
  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])

      @project.teams = [Team.find(params[:team_id])]
      render :inline => "<script>location.reload(true);</script>"
    else
        render :partial => 'form',
        		:object => @project,
        		:locals => { :no_refresh => true, :edit => true, :organization => @project.organization_id },
   		:status => :internal_server_error
    end
  end

  # DELETE /projects/1
  def destroy
    @project = Project.find(params[:id])
    # This is concateneted to [] to create a new array and not just reference it.
    @teams = [] + @project.teams
    if @project.destroy
      @teams.each { |team| team.destroy }
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :internal_server_error
    end
  end
  
  def add_guest
    guest_membership = GuestTeamMembership.new(:project => params[:id], :member => params[:member], :team => params[:team])
    if guest_membership.save
      render :inline => "", :status => :ok
    else
      p guest_membership.errors
      render :inline => "", :status => :internal_server_error
    end
  end

  def remove_guest
    guest_membership = GuestTeamMembership.first(:conditions => ['project_id = ? AND member_id = ? AND team_id = ?', params[:id], params[:member], params[:team] ])
    if guest_membership.destroy
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :internal_server_error
    end
  end
end
