class StatustagsController < ApplicationController
  before_filter :login_required
  # GET /statustags
  # GET /statustags.xml
  def index
    @statustags = Statustag.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @statustags }
    end
  end

  # GET /statustags/1
  # GET /statustags/1.xml
  def show
    @statustag = Statustag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @statustag }
    end
  end

  # GET /statustags/new
  # GET /statustags/new.xml
  def new
    @statustag = Statustag.new
    if params[:story]
      @story = Story.find(params[:story])
      @tasks = @story.tasks.collect { |project| [project.name, project.id] }
    else
      @tasks = Task.find(:all).collect { |project| [project.name, project.id] }
    end 
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @statustag }
    end
  end

  # GET /statustags/1/edit
  def edit
    @statustag = Statustag.find(params[:id])
  end

  # POST /statustags
  # POST /statustags.xml
  def create
    @statustag = Statustag.new(params[:statustag])
    @task = Task.find(params[:task_id])
    @statustag.task = @task
    @statustag.color = rand(41)
    
    respond_to do |format|
      if @statustag.save
        flash[:notice] = 'Statustag was successfully created.'
        format.html { redirect_to(:controller => :projects, :action => :show , :id => @task.story.project_id) }
        format.xml  { render :xml => @statustag, :status => :created, :location => @statustag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @statustag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statustags/1
  # PUT /statustags/1.xml
  def update
    @statustag = Statustag.find(params[:id])

    respond_to do |format|
      if @statustag.update_attributes(params[:statustag])
        flash[:notice] = 'Statustag was successfully updated.'
        format.html { redirect_to(@statustag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @statustag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statustags/1
  # DELETE /statustags/1.xml
  def destroy
    @statustag = Statustag.find(params[:id])
    @statustag.destroy

    respond_to do |format|
      format.html { redirect_to(statustags_url) }
      format.xml  { head :ok }
    end
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
