class BacklogController < ApplicationController
  def index
      @project = Project.find(params[:project])
      @stories = @project.stories_by_priority
  end

end
