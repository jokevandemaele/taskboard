class TasksController < ApplicationController
  before_filter :require_user
  before_filter :require_belong_to_project_or_admin
  before_filter :find_story
  before_filter :find_task, :only => [ :edit, :update, :destroy, :start, :stop, :finish, :update_name, :update_description, :update_color ]
  before_filter :update_story, :only => [:start, :stop, :finish]
  layout nil

  # GET /projects/:project_id/stories/:story_id/tasks
  def index
    @tasks = @story.tasks
    render :json => @tasks, :status => :ok
  end
  
  # GET /projects/:project_id/stories/:story_id/tasks/new
  def new
    @task = @story.tasks.build
  end
  
  # POST /projects/:project_id/stories/:story_id/tasks
  def create
    @task = @story.tasks.build(params[:task])
    @task.save
    render :json => { :project => @story.project_id, :story => @story.id }, :status => :created
  end

  # GET /projects/:project_id/stories/:story_id/tasks/:id
  def edit
  end
  
  def update_name
    @task.name = params[:value]
    @task.save
    render :json => @task.name, :status => :ok
  end

  def update_description
    @task.description = params[:value]
    @task.save
    render :json => @task.description, :status => :ok
  end

  def update_color
    @task.color = params[:value]
    @task.save
    render :json => @task.color, :status => :ok
  end

  # DELETE /projects/:project_id/stories/:story_id/tasks/:id
  def destroy
    @task.destroy
    render :json => '', :status => :ok
  end  

  # POST /projects/:project_id/stories/:story_id/tasks/:id/start
  def start
    @task.start
    render :json => '', :status => :ok
  end

  # POST /projects/:project_id/stories/:story_id/tasks/:id/stop
  def stop
    @task.stop
    render :json => '', :status => :ok
  end

  # POST /projects/:project_id/stories/:story_id/tasks/:id/finish
  def finish
    @task.finish
    render :json => '', :status => :ok
  end

private
  def find_task
    @task = @story.tasks.find(params[:id])
  end
  
  def update_story
    if params[:new_story_id] && @task.story.id != params[:new_story_id]
      @task.story = Story.find(params[:new_story_id])
      @task.save
    end
  end
end
