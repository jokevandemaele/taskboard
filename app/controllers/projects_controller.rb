class ProjectsController < ApplicationController
  before_filter :login_required

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
    @stories_by_priority = @project.stories_in_progress
    @members = @project.members

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
  
  def show_new_task
    @story = Story.find(params[:story])
    @task = Task.new
    render :update do |page|
      page.replace_html "dummy-for-actions", :partial => 'tasks/add', :locals => { :task => @task, :story => @story, :status => params[:status], :x => params[:x],:y => params[:y] }
    end
  end
  
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
      page.replace_html "menu_statustags", :partial => "menu_statustags"
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
      page.replace_html "menu_nametags", :partial => "menu_nametags", :locals => { :members => @task.story.project.members }
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


  def add_team_to_project
    @project = Project.find(params[:id])
    @teams = Team.find(:all).collect { |team| [team.name, team.id] }
  end

  def create_team_to_project_relation
    @project = Project.find(params[:id])
    @team = Team.find(params[:team_id])
    if !@project.teams.exists?(@team)
      @project.teams << @team
      @project.save
    end
    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  def delete_team_to_project_relation
    @project = Project.find(params[:id])
    @team = Team.find(params[:team_id])
    if @project.teams.exists?(@team)
      @project.teams.delete(@team)
      @project.save
    end
    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
