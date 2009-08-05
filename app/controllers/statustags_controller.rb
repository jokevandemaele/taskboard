class StatustagsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
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
      logger.error(params.inspect)
      @task = Task.find(params[:task])
      @tag = Statustag.find(params[:tag_id])
      @tag.relative_position_x = params[:x]
      @tag.relative_position_y = params[:y]
      @tag.task = @task
      @tag.save
      render :update do |page|
        page.replace_html "dummy-for-actions", :partial => "taskboard/empty_dummy", :locals => { :tasks => @task.story.tasks, :status => @task.status } 
      end
    end
  end

  # DELETE /statustags/1?statustag=id
  def destroy
    @tag = Statustag.find(params[:statustag])
    @html_id = 'statustag-' + @tag.id.to_s
    if @tag.destroy
      render :inline => "<script>Effect.Fade($('#{@html_id}'), {duration: 0.3});</script>", :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end
  
end
