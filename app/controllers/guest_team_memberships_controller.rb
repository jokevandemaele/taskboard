class GuestTeamMembershipsController < ApplicationController
  before_filter :require_organization_admin
  before_filter :find_organization
  before_filter :find_project, :except => [ :new, :edit ]
  before_filter :find_guest_team_membership, :only => [:edit, :update, :destroy]
  # POST /organizations/[organization_id]/guest_team_memberships/new
  def new
  end

  # POST /organizations/[organization_id]/guest_team_memberships
  def create
    @user = User.find_by_email(params[:email])
    @guest_team_membership = @project.guest_team_memberships.build(:user => @user)
    if @guest_team_membership.save
      UserMailer.deliver_add_guest_to_projects(@user, current_user.name, [@project])
      render :json => @guest_team_membership, :status => :created
    else
      render :json => @guest_team_membership.errors, :status => :precondition_failed
    end
  end

  # DELETE /projects/1
  def destroy
    if @guest_team_membership.destroy
      render :json => '', :status => :ok
    end
  end

private
  def find_project
    @project = @organization.projects.find(params[:project_id])
  end
  def find_guest_team_membership
    @guest_team_membership = @project.guest_team_memberships.first(:conditions => ['user_id = ?', params[:id]])
  end
end
