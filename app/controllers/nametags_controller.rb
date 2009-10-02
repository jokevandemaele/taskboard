class NametagsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # POST /nametags
  def create
    @project = Project.find(params[:project_id])
    @nametag = Nametag.new(params[:nametag])
    if @project.stories.include?(@nametag.task.story) && @nametag.save
      render :inline => '', :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end

  # PUT /nametags/1
  def update
    @project = Project.find(params[:project_id])
    @nametag = Nametag.find(params[:id])
    @nametag.update_attributes(params[:nametag])
    if @project.stories.include?(@nametag.task.story) && @nametag.save
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end

  # DELETE /nametags/1?nametag=id
  def destroy
    @tag = Nametag.find(params[:id])
    @html_id = "nametag-project-#{@tag.task.story.project.id}-#{@tag.id.to_s}"
    if @tag.destroy
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end
end
