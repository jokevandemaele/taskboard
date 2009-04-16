class NametagsController < ApplicationController
  before_filter :login_required

  # POST /nametags
  def create
    if request.xhr?
      @task = Task.find(params[:task])
      @member = Member.find(params[:member])
      @tag = Nametag.new
      @tag.relative_position_x = params[:x]
      @tag.relative_position_y = params[:y]
      @tag.task = @task
      @tag.member = @member
      @tag.save

      render :update do |page|
        @tasks = Task.tasks_by_status(@task.story,@task.status)
        page.replace_html "#{@task.status}-#{@task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @tasks  } 
        page.replace_html "menu_nametags", :partial => "taskboard/menu_nametags", :locals => { :members => @task.story.project.members }
      end
    end
  end

  # PUT /nametags/1
  def update
    if request.xhr?
      @task = Task.find(params[:task])
      @tag = Nametag.find(params[:tagid])
      @tag.relative_position_x = params[:x]
      @tag.relative_position_y = params[:y]
      @tag.task = @task
      @tag.save
      render :update do |page|
        page.replace_html "dummy-for-actions", ""
      end
    end
  end

  # DELETE /nametags/1
  def destroy
    @nametag = Nametag.find(params[:id])
    @nametag.destroy

    redirect_to(nametags_url)
  end
  
  # These functions are used by the taskboard. TODO: See how to avoid them to use the resources
  def destroy_nametag
    @tag = Nametag.find(params[:nametag])
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
