class Admin::TeamsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # GET /teams
  def index

    if(params[:project])
	    @project = Project.find(params[:project])
	    @teams = @project.teams
      @members = @project.organization.members
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
    if params[:project_id]
        @project = Project.find(params[:project_id])
        @project.teams << @team
        @project.save
    end

    if(params[:dynamic])
      @team.save
      render :inline => "<script>location.reload(true);</script>"
    else
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        redirect_to(@team)
      else
        render :action => "new"
      end
    end
  end

  # PUT /teams/1
  def update
    @team = Team.find(params[:id])

    if(params[:dynamic])
      @team.update_attributes(params[:team])
      render :inline => "<script>location.reload(true);</script>"
    else
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        redirect_to(@team)
      else
        render :action => "edit"
      end
    end
  end

  # DELETE /teams/1
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    redirect_to(teams_url)
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
      page.replace_html "team-members-list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }
      page.replace_html "members-list", :partial => "teams/members_list", :locals => { :members => @team.projects.first.organization.members, :project => params[:project] }
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
      page.replace_html "team-members-list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }
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
