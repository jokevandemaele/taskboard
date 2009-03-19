class TasksController < ApplicationController
  before_filter :login_required
  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = Task.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new
    # Check if a story has been sent as a parameter, if not put a list of stories
    if params[:story]
      @story = Story.find(params[:story]) 
    else
      @stories = Story.find(:all).collect { |story| [story.name, story.id] }
    end 
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
    @task.story = Story.find(params[:story_id])
    @task.status = params[:status]
    if params[:task][:description] == "Description"
      @task.description = ""
    end
    
    respond_to do |format|
      if @task.save
        format.html { render :partial => "tasks/tasks_by_status", :locals => { :tasks => @task.story.tasks, :status => @task.status, :new_task => true } }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to(@task) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.nametags.each {|nametag| nametag.destroy }
    @task.statustags.each {|statustag| statustag.destroy }
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
  
  # These functions are used by the taskboard. TODO: See how to avoid them
  def destroy_task
    @task = Task.find(params[:task])
    id = @task.id
    old_status = @task.status
    story = @task.story
    story_id = @task.story_id
    @task.destroy
    
    render :update do |page|
      page.replace_html "#{old_status}-#{story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => story.tasks, :status => old_status } 
    end
  end

  def show_form
    @story = Story.find(params[:story])
    @task = Task.new
    render :update do |page|
      page.replace_html "dummy-for-actions", :partial => 'tasks/form', :locals => { :task => @task, :story => @story, :status => params[:status], :x => params[:x],:y => params[:y] }
    end
  end

  def update_task
    @task = Task.find(params[:task])
    old_status = @task.status
    @task.status = params[:status]
    @task.relative_position_x = params[:x]
    @task.relative_position_y = params[:y]
    if(@task.status == 'finished')
	@task.remove_tags
    end
    @task.save

    render :update do |page|
      page.replace_html "#{params[:status]}-#{@task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @task.story.tasks, :status => params[:status] } 
      page.replace_html "#{old_status}-#{@task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @task.story.tasks, :status => old_status } 
    end
  end

end
