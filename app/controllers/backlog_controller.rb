class BacklogController < ApplicationController
  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
    end
  end

end
