class NametagsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # POST /nametags
  def create
    @project = Project.find(params[:project_id])
    @nametag = Nametag.new(params[:nametag])
    if @project.stories.include?(@nametag.task.story) && @nametag.save
     render :update do |page|
       @members = @nametag.task.story.project.members
       @member_team = @nametag.task.story.project.team_including(@current_member)        
       page.replace_html "task-#{@nametag.task.id}-project-#{@nametag.task.story.project.id}-li", :partial => "tasks/task", :object => @nametag.task
       page.replace_html "menu_nametags", :partial => "taskboard/menu_nametags", :locals => { :team => @member_team, :members => @members }
     end
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
