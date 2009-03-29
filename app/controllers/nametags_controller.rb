class NametagsController < ApplicationController
  before_filter :login_required

  # GET /nametags
  def index
    @nametags = Nametag.find(:all)
  end

  # GET /nametags/1
  def show
    @nametag = Nametag.find(params[:id])
  end

  # GET /nametags/new
  def new
    @nametag = Nametag.new
    if params[:story]
      @story = Story.find(params[:story])
      @tasks = @story.tasks.collect { |project| [project.name, project.id] }
    else
      @tasks = Task.find(:all).collect { |project| [project.name, project.id] }
    end 
  end

  # GET /nametags/1/edit
  def edit
    @nametag = Nametag.find(params[:id])
  end

  # POST /nametags
  def create
    @nametag = Nametag.new(params[:nametag])
    @task = Task.find(params[:task_id])
    @nametag.task = @task
    @nametag.color = rand(41)
    
    if @nametag.save
      flash[:notice] = 'Nametag was successfully created.'
      redirect_to(:controller => :projects, :action => :show , :id => @task.story.project_id)
    else
      render :action => "new"
    end
  end

  # PUT /nametags/1
  def update
    @nametag = Nametag.find(params[:id])

    if @nametag.update_attributes(params[:nametag])
      flash[:notice] = 'Nametag was successfully updated.'
      redirect_to(@nametag)
    else
      render :action => "edit"
    end
  end

  # DELETE /nametags/1
  def destroy
    @nametag = Nametag.find(params[:id])
    @nametag.destroy

    redirect_to(nametags_url)
  end
  
  # These functions are used by the taskboard. TODO: See how to avoid them to use the resources
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
