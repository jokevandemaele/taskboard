class BacklogController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  def show
      @view = :project
      @project = Project.find(params[:id])
      @stories = @project.stories_by_priority
      @projects = [@project]

      @member = @current_member
      @member.last_project = @project
      @member.save

      @member_team = @project.team_including(@member)
  end

  def team
      @view = :team
      @member_team = Team.find(params[:id])
      @projects = @member_team.projects
      @stories = Story.find_by_team(@member_team)
   end

end
