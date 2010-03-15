class BacklogController < ApplicationController
  before_filter :require_user
  before_filter :member_belongs_to_project, :only => :show
  before_filter :team_belongs_to_project, :only => :team

  def index
      @view = :project
      @project = Project.find(params[:project_id])
      @stories = @project.stories
      @projects = [@project]

      @member = current_user
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
