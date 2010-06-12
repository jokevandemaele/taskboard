class TaskboardController < ApplicationController
  before_filter :require_belong_to_project_or_auth_guest, :only => :index
  before_filter :require_user, :only => :team
  before_filter :require_belong_to_team, :only => :team
  # before_filter :team_belongs_to_project, :only => :team
  layout 'taskboard'
  def index
    @view = :project
    @project = Project.find(params[:project_id])
    @stories_by_priority = @project.stories.in_progress

    if(current_user)
      current_user.last_project = @project
      current_user.save
    end
    
    @team = @project.team_including(current_user)
    @color = @team.color || '0C82EB'
    @projects = [@project]
    @users = @project.users
  end

  def team
      @view = :team
      @members = @team.users
      @projects = @team.projects
      @stories_by_priority = []
      @projects.each do |project|
        @stories_by_priority = @stories_by_priority | project.stories.in_progress
      end
      @stories_by_priority = @stories_by_priority.sort_by {|story| story.priority }
      @stories_by_priority = @stories_by_priority.reverse
      @color = @team.color || '0C82EB'
      @users = @team.users
  end
end
