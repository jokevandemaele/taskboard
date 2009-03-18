class NametagsController < ApplicationController
  before_filter :login_required
  # GET /nametags
  # GET /nametags.xml
  def index
    @nametags = Nametag.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nametags }
    end
  end

  # GET /nametags/1
  # GET /nametags/1.xml
  def show
    @nametag = Nametag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nametag }
    end
  end

  # GET /nametags/new
  # GET /nametags/new.xml
  def new
    @nametag = Nametag.new
    if params[:story]
      @story = Story.find(params[:story])
      @tasks = @story.tasks.collect { |project| [project.name, project.id] }
    else
      @tasks = Task.find(:all).collect { |project| [project.name, project.id] }
    end 
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nametag }
    end
  end

  # GET /nametags/1/edit
  def edit
    @nametag = Nametag.find(params[:id])
  end

  # POST /nametags
  # POST /nametags.xml
  def create
    @nametag = Nametag.new(params[:nametag])
    @task = Task.find(params[:task_id])
    @nametag.task = @task
    @nametag.color = rand(41)
    
    respond_to do |format|
      if @nametag.save
        flash[:notice] = 'Nametag was successfully created.'
        format.html { redirect_to(:controller => :projects, :action => :show , :id => @task.story.project_id) }
        format.xml  { render :xml => @nametag, :status => :created, :location => @nametag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nametag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nametags/1
  # PUT /nametags/1.xml
  def update
    @nametag = Nametag.find(params[:id])

    respond_to do |format|
      if @nametag.update_attributes(params[:nametag])
        flash[:notice] = 'Nametag was successfully updated.'
        format.html { redirect_to(@nametag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nametag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nametags/1
  # DELETE /nametags/1.xml
  def destroy
    @nametag = Nametag.find(params[:id])
    @nametag.destroy

    respond_to do |format|
      format.html { redirect_to(nametags_url) }
      format.xml  { head :ok }
    end
  end
  
  # These functions are used by the taskboard. TODO: See how to avoid them
  def add_nametag
    @task = Task.find(params[:task])
    @member = Member.find(params[:member])
    @tag = Nametag.new
    @tag.relative_position_x = params[:x]
    @tag.relative_position_y = params[:y]
    @tag.task = @task
    @tag.member = @member
    @tag.save
    render :update do |page|
      page.replace_html "#{@task.status}-#{@task.story_id}", :partial => "tasks/tasks_by_status", :locals => { :tasks => @task.story.tasks, :status => @task.status } 
      page.replace_html "menu_nametags", :partial => "taskboard/menu_nametags", :locals => { :members => @task.story.project.members }
    end
  end

  def update_nametag
    @task = Task.find(params[:task])
    @tag = Nametag.find(params[:id])
    @tag.relative_position_x = params[:x]
    @tag.relative_position_y = params[:y]
    @tag.task = @task
    @tag.save
    render :update do |page|
      page.replace_html "dummy-for-actions", :partial => "empty_dummy", :locals => { :tasks => @task.story.tasks, :status => @task.status } 
    end
  end

  def destroy_nametag
    @tag = Nametag.find(params[:nametag])
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
