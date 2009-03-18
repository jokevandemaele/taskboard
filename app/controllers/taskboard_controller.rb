class TaskboardController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @stories_by_priority = @project.stories_in_progress
    @members = @project.members
  end
end
