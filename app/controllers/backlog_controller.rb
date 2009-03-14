class BacklogController < ApplicationController
  #before_filter :login_required

  def index
      @project = Project.find(params[:project])
      @stories = @project.stories_by_priority
  end
end
