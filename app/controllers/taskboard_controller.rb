class TaskboardController < ApplicationController
  #before_filter :user_belongs_to_project_or_auth_guest, :only => :index
  # before_filter :member_belongs_to_project, :only => :show
  before_filter :require_user, :only => :team
  before_filter :team_belongs_to_project, :only => :team
  layout 'taskboard'
  def index
    @view = :project
    @project = Project.find(params[:project_id])
    @stories_by_priority = @project.stories.in_progress

    if(current_user)
      current_user.last_project = @project
      current_user.save
    end
    
    @member_team = @project.team_including(current_user)
    @color = @member_team.color || '0C82EB'
    @projects = [@project]
    @members = @project.users
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
