class StatustagsController < ApplicationController
  before_filter :login_required
  # POST /statustags
  def create
    if request.xhr?
      @task = Task.find(params[:task])
      @tag = Statustag.new
      @tag.relative_position_x = params[:x]
      @tag.relative_position_y = params[:y]
      @tag.task = @task
      @tag.status = params[:status]
      @tag.save
      render :update do |page|
        @tasks = Task.tasks_by_status(@task.story,@task.status)
        page.replace_html "#{@task.status}-#{@task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @tasks  } 
        page.replace_html "menu_statustags", :partial => "taskboard/menu_statustags"
      end
    end
  end

  # PUT /statustags/1
  def update
    if request.xhr?
      @task = Task.find(params[:task])
      @tag = Statustag.find(params[:id])
      @tag.relative_position_x = params[:x]
      @tag.relative_position_y = params[:y]
      @tag.task = @task
      @tag.save
      render :update do |page|
        page.replace_html "dummy-for-actions", :partial => "taskboard/empty_dummy", :locals => { :tasks => @task.story.tasks, :status => @task.status } 
      end
    end
  end

  # DELETE /statustags/1
  def destroy
    @statustag = Statustag.find(params[:id])
    @statustag.destroy

    redirect_to(statustags_url)
  end
  
  # These functions are used by the taskboard. TODO: See how to avoid them
  def destroy_statustag
    @tag = Statustag.find(params[:statustag])
    id = @tag.task.id
    old_status = @tag.task.status
    story = @tag.task.story
    story_id = @tag.task.story_id
    @tag.destroy
    
    render :update do |page|
      @tasks = Task.tasks_by_status(story,old_status)
      page.replace_html "#{old_status}-#{story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @tasks } 
    end
  end
  
end
