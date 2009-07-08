class Admin::TeamsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # GET /teams
  def index

    if(params[:project])
	    @project = Project.find(params[:project])
	    @teams = @project.teams
      if(@project.organization.members)
        @members = @project.organization.members
      else
        @members = []
      end
    else
      @organizations = current_member.organizations_administered
      @projects = Array.new
      @organizations.each do |organization|
        organization.projects.each {|project| @projects << project }
      end
      @members = Member.all()
      @teams = Team.all()
    end
  end

  # GET /teams/1
  def show
    @team = Team.find(params[:id])
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  def create
    @team = Team.new(params[:team])
    @project = Project.find(params[:project_id])

    if @team.save
      @project.teams << @team
      @project.save
      render :inline => "<script>location.reload(true);</script>"
    else
      render :partial => 'form',
      		:object => @team,
      		:locals => { :no_refresh => true, :edit => false, :project => @project },
 		:status => :internal_server_error
    end
  end

  # PUT /teams/1
  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      render :inline => "<script>location.reload(true);</script>"
    else
      @project = Project.find(params[:project_id])
      render :partial => 'form',
      		:object => @team,
      		:locals => { :no_refresh => true, :edit => true, :project => @project },
 		:status => :internal_server_error
    end
  end

  # DELETE /teams/1
  def destroy
    @team = Team.find(params[:id])
    if @team.destroy
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :internal_server_error
    end

  end

  def add_member
    @team = Team.find(params[:team])
    @member = Member.find(params[:member])
    @members = Member.all()
    if !@team.members.exists?(@member)
      @team.members << @member
      @team.save
    end
    render :update do |page|
      page.replace_html "team_members_list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }
      page.replace_html "members-list", :partial => "members_list", :locals => { :members => @team.projects.first.organization.members, :project => params[:project] }
    end
  end

  def remove_member
    @team = Team.find(params[:team])
    @member = Member.find(params[:member])
    if @team.members.exists?(@member)
      @team.members.delete(@member)
      @team.save
    end
    render :update do |page|
      page.replace_html "team_members_list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }
    end
  end
  
  def show_form
    @edit = false
    if(params[:id])
	    @team = Team.find(params[:id])
	    @edit = true
    else
	    @team = Team.new
    end
    
    @project = Project.find(params[:project]) if (params[:project])
    render :update do |page|
	    if @project       
    		page.replace_html "dummy-for-actions", 
    			:partial => 'form', 
          :object => @team, 
    			:locals => { 
    			  :edit => @edit,
  				  :project =>  @project 
    			}
	    else
    		page.replace_html "dummy-for-actions", 
    			:partial => 'form',
    			:edit => @edit,
    			:object => @team
	    end		
    end
  end
end
