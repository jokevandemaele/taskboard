class TaskboardController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  def show
    @project = Project.find(params[:id])
    @stories_by_priority = @project.stories_in_progress
    @member = current_member
    @members = @project.members
    if(@project.teams.first)
      @color = @project.teams.first.color
    else
      @color = "3771c8"
    end
  end
end
