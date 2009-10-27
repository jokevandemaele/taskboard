class TaskboardController < ApplicationController
  before_filter :login_required
  # before_filter :check_permissions
  before_filter :require_belong_to_project, :only => [:show]
  before_filter :require_belong_to_team, :only => [:team]
  def show
    @view = :project
    @project = Project.find(params[:id])
    @stories_by_priority = @project.stories_in_progress

    current_member.last_project = @project
    current_member.save
    
    @member_team = @project.team_including(@member)
    @color = @member_team.color
    @projects = [@project]
    @members = @project.members
  end

  def team
      @view = :team
      @member_team = Team.find(params[:id])
      @members = @member_team.members
      @projects = @member_team.projects
      @stories_by_priority = []
      @projects.each do |project|
        project.stories_in_progress.each { |story| @stories_by_priority << story }
      end
      @stories_by_priority = @stories_by_priority.sort_by {|story| story.priority }
      @stories_by_priority = @stories_by_priority.reverse
      @color = @member_team.color
  end
end
