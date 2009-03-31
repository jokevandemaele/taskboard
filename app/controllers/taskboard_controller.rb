class TaskboardController < ApplicationController
  before_filter :login_required
  
  def show
    @project = Project.find(params[:id])
    @stories_by_priority = @project.stories_in_progress
    @members = @project.members
    if(@project.teams.first)
      @color = @project.teams.first.color
    else
      @color = "3771c8"
    end
  end
end
