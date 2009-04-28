class BacklogController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  def show
      @project = Project.find(params[:id])
      @stories = @project.stories_by_priority
  end
end
