class TeamsController < ApplicationController
  before_filter :require_user
  before_filter :require_organization_admin, :only => [ :new , :create, :edit, :update, :destroy ]
  before_filter :find_organization, :only => [ :new, :create, :edit, :update, :destroy]

  # layout "application", :only => [ :index ]
  # layout "admin/teams", :except => :display_compact_info
  
  # GET /teams
  # def index
  #   @organizations = current_member.organizations_administered
  #   @teams = []
  #   @organizations.each do |organization|
  #     organization.teams.each { |team| @teams << team }
  #   end
  # end

  # # GET /teams/1
  # def show
  #   @team = Team.find(params[:id])
  # end

  # POST /organizations/[organization_id]/teams/new
  def new
    @team = @organization.teams.build()
  end

  # POST /organizations/[organization_id]/teams
  def create
    @team = @organization.teams.build(params[:team])
    if @team.save
      render :json => @team, :status => :created
    else
      render :json => @team.errors, :status => :precondition_failed
    end
  end

  # GET /organizations/[organization_id]/projects/1/edit
  def edit
    @team = @organization.teams.find(params[:id])
  end

  # PUT /organizations/[organization_id]/projects/1
  def update
    @team = @organization.teams.find(params[:id])
    if @team.update_attributes(params[:team])
      render :json => @team, :status => :ok
    else
      render :json => @team.errors, :status => :precondition_failed
    end
  end

  # DELETE /projects/1
  def destroy
    @team = @organization.teams.find(params[:id])
    if @team.destroy
      render :json => '', :status => :ok
    end
  end

  # def add_member
  #   @team = Team.find(params[:team])
  #   @member = Member.find(params[:member])
  #   if !@team.members.exists?(@member)
  #     @team.members << @member
  #     @team.save
  #   end
  #   render :update do |page|
  #     page.replace_html "members-list", :partial => "members_list", :locals => { :members => @team.projects.first.organization.members, :project => params[:project] }
  #     page.replace_html "team_members_list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }, :collection => @team.members, :as => :member
  #   end
  # end
  # 
  # def remove_member
  #   @team = Team.find(params[:team])
  #   @member = Member.find(params[:member])
  #   if @team.members.exists?(@member)
  #     @team.members.delete(@member)
  #     @team.save
  #   end
  #   render :update do |page|
  #     page.replace_html "team_members_list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }, :collection => @team.members, :as => :member
  #   end
  # end
  # 
  # def display_compact_info
  #   @team = Team.find(params[:id])
  # end

end
