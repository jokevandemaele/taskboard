class StatustagsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # POST /statustags
  def create
    @project = Project.find(params[:project_id])
    @statustag = Statustag.new(params[:statustag])
    if @project.stories.include?(@statustag.task.story) && @statustag.save
      render :update do |page|
        @members = @statustag.task.story.project.members
        @member_team = @statustag.task.story.project.team_including(@member)        
        @tasks = Task.tasks_by_status(@statustag.task.story, @statustag.task.status)
        page.replace_html "#{@statustag.task.status}-#{@statustag.task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @tasks, :story => @statustag.task.story, :status => @statustag.task.status} 
        page.replace_html "menu_statustags", :partial => "taskboard/menu_statustags", :locals => { :team => @member_team }
      end
    else
      render :inline => "", :status => :bad_request
    end
  end

  # PUT /statustags/1
  def update
    @project = Project.find(params[:project_id])
    @statustag = Statustag.find(params[:id])
    @statustag.update_attributes(params[:statustag])
    if @project.stories.include?(@statustag.task.story) && @statustag.save
      logger.error("saved!")
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
