class StatustagsController < ApplicationController
  before_filter :login_required
  # GET /statustags
  def index
    @statustags = Statustag.find(:all)
  end

  # GET /statustags/1
  def show
    @statustag = Statustag.find(params[:id])
  end

  # GET /statustags/new
  def new
    @statustag = Statustag.new
    if params[:story]
      @story = Story.find(params[:story])
      @tasks = @story.tasks.collect { |project| [project.name, project.id] }
    else
      @tasks = Task.find(:all).collect { |project| [project.name, project.id] }
    end 
  end

  # GET /statustags/1/edit
  def edit
    @statustag = Statustag.find(params[:id])
  end

  # POST /statustags
  def create
    @statustag = Statustag.new(params[:statustag])
    @task = Task.find(params[:task_id])
    @statustag.task = @task
    @statustag.color = rand(41)
    
    if @statustag.save
      redirect_to(:controller => :projects, :action => :show , :id => @task.story.project_id)
    else
      render :action => "new"
    end
  end

  # PUT /statustags/1
  def update
    @statustag = Statustag.find(params[:id])

    if @statustag.update_attributes(params[:statustag])
      flash[:notice] = 'Statustag was successfully updated.'
      redirect_to(@statustag)
    else
      render :action => "edit"
    end
  end

  # DELETE /statustags/1
  def destroy
    @statustag = Statustag.find(params[:id])
    @statustag.destroy

    redirect_to(statustags_url)
  end
  
  # These functions are used by the taskboard. TODO: See how to avoid them
  def add_statustag
    @task = Task.find(params[:task])
    @tag = Statustag.new
    @tag.relative_position_x = params[:x]
    @tag.relative_position_y = params[:y]
    @tag.task = @task
    @tag.status = params[:status]
    @tag.save
    render :update do |page|
      page.replace_html "#{@task.status}-#{@task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @task.story.tasks, :status => @task.status } 
      page.replace_html "menu_statustags", :partial => "taskboard/menu_statustags"
    end
  end

  def update_statustag
    @task = Task.find(params[:task])
    @tag = Statustag.find(params[:id])
    @tag.relative_position_x = params[:x]
    @tag.relative_position_y = params[:y]
    @tag.task = @task
    @tag.save
    render :update do |page|
      page.replace_html "dummy-for-actions", :partial => "empty_dummy", :locals => { :tasks => @task.story.tasks, :status => @task.status } 
    end
  end

  def destroy_statustag
    @tag = Statustag.find(params[:statustag])
    id = @tag.task.id
    old_status = @tag.task.status
    story = @tag.task.story
    story_id = @tag.task.story_id
    @tag.destroy
    
    render :update do |page|
      page.replace_html "#{old_status}-#{story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => story.tasks, :status => old_status } 
    end
  end
  
end
