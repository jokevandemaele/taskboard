class TeamsController < ApplicationController
  before_filter :require_user
  before_filter :require_organization_admin, :except => [ :team_info ]
  before_filter :find_organization
  before_filter :find_user, :only => [ :add_user, :remove_user]
  layout :set_layout

  # GET /organizations/[organization_id]/teams/1
  def show
    @team = @organization.teams.find(params[:id])
  end

  # GET /organizations/[organization_id]/teams/1/team_info
  def team_info
    @team = @organization.teams.find(params[:id])
  end

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

  # GET /organizations/[organization_id]/teams/1/edit
  def edit
    @team = @organization.teams.find(params[:id])
  end

  # PUT /organizations/[organization_id]/teams/1
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

  # POST /organizations/:organization_id/teams/:id/users/:user_id
  def add_user
    @team = @organization.teams.find(params[:id])
    if !@team.users.include?(@user)
      @team.users << @user
      render :json => '', :status => :ok
    else
      render :json => ['user', 'is already a team member'], :status => :precondition_failed
    end
  end

  # delete /organizations/:organization_id/teams/:id/users/:user_id
  def remove_user
    @team = @organization.teams.find(params[:id])
    @team.users.delete(@user)
    render :json => '', :status => :ok
  end
  
private 
  def find_user
    @user = @organization.users.find(params[:user_id])
  end
  
  def set_layout
    request.xhr? ? nil : 'application'
  end
  
end
