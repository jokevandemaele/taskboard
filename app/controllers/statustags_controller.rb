class StatustagsController < ApplicationController
  before_filter :login_required
  before_filter :member_belongs_to_project
  
  # POST /statustags
  def create
    @project = Project.find(params[:project_id])
    @statustag = Statustag.new(params[:statustag])
    if @project.stories.include?(@statustag.task.story) && @statustag.save
      render :inline => '', :status => :ok
    else
      render :inline => '', :status => :bad_request
    end
  end

  # PUT /statustags/1
  def update
    @project = Project.find(params[:project_id])
    @statustag = Statustag.find(params[:id])
    @statustag.update_attributes(params[:statustag])
    if @project.stories.include?(@statustag.task.story) && @statustag.save
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end

  # DELETE /statustags/1?statustag=id
  def destroy
    @tag = Statustag.find(params[:id])
    @html_id = "statustag-project-#{@tag.task.story.project.id}-#{@tag.id.to_s}"
    if @tag.destroy
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end
end
