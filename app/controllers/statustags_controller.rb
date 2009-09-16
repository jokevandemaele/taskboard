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
        page.replace_html "#{@statustag.task.status}-#{@statustag.task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @tasks  } 
        page.replace_html "menu_statustags", :partial => "taskboard/menu_statustags", :locals => { :team => @member_team }
      end
    else
      render :inline => "", :status => :bad_request
    end
  end

  # PUT /statustags/1
  def update
    @project = Project.find(params[:project_id])
    @statustag = Statustag.find(params[:statustag_id])
    @statustag.update_attributes(params[:statustag])
    if @project.stories.include?(@statustag.task.story) && @statustag.save
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end

  # DELETE /statustags/1?statustag=id
  def destroy
    @tag = Statustag.find(params[:statustag_id])
    @html_id = 'statustag-' + @tag.id.to_s
    @tag.destroy
    render :inline => "<script>Effect.Fade($('#{@html_id}'), {duration: 0.3});</script>", :status => :ok
  end
  
end
