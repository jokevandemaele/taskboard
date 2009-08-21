class TaskboardController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  def show
    @view = 'project'
    @project = Project.find(params[:id])
    @stories_by_priority = @project.stories_in_progress
    @member = @current_member
    @project.teams.each do |team|
      @member_team = team if(team.members.include?(@member))
    end


    if(@member_team)
      @color = @member_team.color
    else
      @color = "3771c8"
      @member_team = @project.teams.first
    end
    @projects = [@project]
  end

  def team
      @view = 'team'
      @member_team = Team.find(params[:id])
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
