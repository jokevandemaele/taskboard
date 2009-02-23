class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    @stories_by_priority = Story.find(:all, :conditions => "project_id = #{@project.id}", :order => "priority DESC")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  def update_task
    @task = Task.find(params[:task])
    @task.status = params[:status]
    @task.relative_position_x = params[:x]
    @task.relative_position_y = params[:y]
    @task.save

    render :update do |page|
      page.replace_html "story-#{@task.story_id}", :partial => "stories/show", :locals => { :story => @task.story, :project => @task.story.project_id } 
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
      page.replace_html "story-#{@task.story_id}", :partial => "stories/story", :locals => { :story => @task.story, :project => @task.story.project_id } 
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
      page.replace_html "story-#{@task.story_id}", :partial => "stories/story", :locals => { :story => @task.story, :project => @task.story.project_id } 
    end
  end
end
