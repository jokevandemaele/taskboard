class TasksController < ApplicationController
  before_filter :require_user
  before_filter :require_belong_to_project_or_admin
  before_filter :find_story
  before_filter :find_task, :only => [ :edit, :update, :destroy, :start, :stop, :finish, :update_name, :update_description ]
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
  
  # PUT /projects/:project_id/stories/:story_id/tasks/:id
  # def update
  #   if params[:editorId]
  #     @task.name = params[:value] if params[:editorId].match(/edit_name/)
  #     render :json => @task, :status => :ok
  #   else
  #     render :json => @task.errors, :status => :precondition_failed
  #   end
  # end

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

  # # GET /tasks
  # def index
  #   @tasks = Task.find(:all)
  # end

  # GET /tasks/1
  # def show
  #   @task = Task.find(params[:id])
  # end
  # 
  # # GET /tasks/new
  # def new
  #   @task = Task.new
  #   # Check if a story has been sent as a parameter, if not put a list of stories
  #   if params[:story]
  #     @story = Story.find(params[:story]) 
  #   else
  #     @stories = Story.find(:all).collect { |story| [story.name, story.id] }
  #   end 
  # end
  # 
  # # GET /tasks/1/edit
  # def edit
  #   @task = Task.find(params[:id])
  # end
  # 
  # # POST /tasks
  # def create
  #   @task = Task.new(params[:task])
  #   @task.story = Story.find(params[:story_id])
  #   @task.status = params[:status]
  #   if params[:task][:description] == "Description"
  #     @task.description = ""
  #   end
  #   
  #   if @task.save
  #     @tasks = Task.tasks_by_status(@task.story,params[:status])
  #     render :partial => "tasks/tasks_by_status", :locals => { :tasks => @tasks, :new_task => true, :story => @task.story, :status => params[:status] }
  #   else
  #     render :action => "new"
  #   end
  # end
  # 
  # # PUT /tasks/1
  # def update
  #   @task = Task.find(params[:id])
  # 
  #   if @task.update_attributes(params[:task])
  #     render :update do |page|
  #       page.replace_html "task-#{@task.id}-project-#{@task.story.project.id}-li", :partial => 'task', :object => @task
  #     end
  #   else
  #     render :inline => "", :status => :internal_server_error
  #   end
  # end
  # 
  # # DELETE /tasks/1
  # def destroy
  #   @task = Task.find(params[:id])
  #   @html_id = "task-#{@task.id.to_s}-project-#{@task.story.project.id}-li"
  #   if @task.destroy
  #     render :inline => "<script>Effect.Fade($('#{@html_id}'), {duration: 0.2});</script>", :status => :ok
  #   else
  #     render :inline => "", :status => :bad_request
  #   end
  # end
  # 
  # # These functions are used by the taskboard. TODO: See how to avoid them
  # def show_form
  #   @story = Story.find(params[:story])
  #   @task = Task.new
  #   render :update do |page|
  #     page.replace_html "dummy-for-actions", :partial => 'tasks/form', :locals => { :task => @task, :story => @story, :status => params[:status], :x => params[:x],:y => params[:y] }
  #   end
  # end
  # 
  # def show_edit_task_name_form
  #   @story = Story.find(params[:story])
  #   @task = Task.find(params[:id])
  #   render :update do |page|
  #     page.replace_html "task-#{@task.id}-name", :partial => 'tasks/edit_task_name', :locals => { :task => @task, :story => @story, :status => params[:status], :x => params[:x],:y => params[:y] }
  #   end
  # end
  # 
  # def show_edit_task_description_form
  #   @story = Story.find(params[:story])
  #   @task = Task.find(params[:id])
  #   render :update do |page|
  #     page.replace_html "task-#{@task.id}-description", :partial => 'tasks/edit_task_description', :locals => { :task => @task, :story => @story, :status => params[:status], :x => params[:x],:y => params[:y] }
  #   end
  # end
  # 
  # def update_task
  #   @task = Task.find(params[:task])
  #   @story = Story.find(params[:story])
  #   old_status = @task.status
  #   old_story = @task.story
  #   @task.status = params[:status]
  #   @task.relative_position_x = params[:x]
  #   @task.relative_position_y = params[:y]
  #   @task.story = @story
  #   if(@task.status == 'finished')
  #       @task.remove_tags
  #   end
  #   if @task.save
  #     render :inline => '', :status => :ok
  #   else
  #     render :inline => '', :status => :internal_server_error
  #   end
  # end
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
