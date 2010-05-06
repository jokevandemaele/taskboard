class BacklogController < ApplicationController
  before_filter :require_user
  before_filter :require_belong_to_project_or_admin, :only => :index
  before_filter :require_belong_to_team, :only => :team

  def index
      @view = :project
      @project = Project.find(params[:project_id])
      @stories = @project.stories
      @projects = [@project]

      @member = current_user
      @member.last_project = @project
      @member.save

      @team = @project.team_including(@member)
  end

  def team
      @view = :team
      @team = Team.find(params[:team_id])
      @projects = @team.projects
      @stories = @team.stories
   end

end
