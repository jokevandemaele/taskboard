class StoriesController < ApplicationController
  before_filter :require_user
  before_filter :require_belong_to_project_or_admin
  before_filter :find_story, :only => [ :edit, :update, :destroy, :start, :stop, :finish, :update_priority, :update_size ]
  layout nil

  # GET /projects/:project_id/stories
  def index
    @stories = @project.stories
    render :json => @stories, :status => :ok
  end
  
  # GET /projects/:project_id/stories/new
  def new
    @story = @project.stories.build
  end
  
  # POST /projects/:project_id/stories
  def create
    @story = @project.stories.build(params[:story])
    # Don't know why but this is not setting the id and priority automatically
    @story.realid = @project.next_realid
    @story.priority = @story.default_priority
    if @story.save
      render :json => @story, :status => :created
    else
      render :json => @story.errors, :status => :precondition_failed
    end
  end

  # GET /projects/:project_id/stories/:id
  def edit
  end
  
  # PUT /projects/:project_id/stories
  def update
    if @story.update_attributes(params[:story])
      render :json => @story, :status => :ok
    else
      render :json => @story.errors, :status => :precondition_failed
    end
  end
  
  # DELETE /projects/:project_id/stories/:id
  def destroy
    @story = @project.stories.find(params[:id])
    @story.destroy
    render :json => '', :status => :ok
  end
  
  # POST /projects/:project_id/stories/:id/start
  def start
    @story.start
    render :json => '', :status => :ok
  end

  # POST /projects/:project_id/stories/:id/stop
  def stop
    @story.stop
    render :json => '', :status => :ok
  end

  # POST /projects/:project_id/stories/:id/finish
  def finish
    @story.finish
    render :json => '', :status => :ok
  end

  # POST /projects/:project_id/stories/:id/update_priority
  def update_priority
    @story.priority = params[:value]
    if @story.save
      render :inline => @story.priority, :status => :ok
    else
      render :inline => '', :status => :precondition_failed
    end
  end

  # POST /projects/:project_id/stories/:id/update_size
  def update_size
    @story.size = params[:value]
    if @story.save
      render :inline => @story.size, :status => :ok
    else
      render :inline => '', :status => :precondition_failed
    end
  end
 #  # GET /stories/1
 #  def show
 #    @story = Story.find(params[:id])
 #  end
 # 
 #  # GET /stories/new
 #  def new
 #    @project = (params[:project]) ? params[:project] : nil
 #    @projects = (params[:project]) ? [Project.find(params[:project])] : Team.find(params[:team]).projects
 #    @story_ids = []
 #    @next_priorities = []
 #    @story = (params[:project]) ? Story.new(:project_id => params[:project]) : Story.new(:project_id => @projects.first.id )
 # 
 #    # @lowest_priority = 
 #    
 #    @projects.each do |project| 
 #      @story_ids[project.id] = Story.next_realid(project.id)
 #      @next_priorities[project.id] = project.next_priority
 #      # @story.priority = @next_priorities[project.id] # if @next_priorities[project.id] < @story.priority
 #    end
 # 
 #    @story.priority = @next_priorities[@projects.first.id]
 # 
 #    render :partial => 'form', :object => @story, :locals => { :edit => false, :project =>  @project, :story_ids => @story_ids, :story_priorities => @story_priorities, :next_priorities => @next_priorities}, :status => :ok
 #  end
 # 
 #  # GET /stories/1/edit
 #  def edit
 #    @story = Story.find(params[:id])
 #    render :partial => 'form', :object => @story, :locals => { :edit => true, :project => @story.project.id }, :status => :ok
 #  end
 # 
 #  # POST /stories
 #  def create
 #    @story = Story.new(params[:story])
 #    if @story.save
 #      render :inline => "<script>location.reload(true);</script>", :status => :created
 #    else
 #      @project = (@story.project_id) ? @story.project_id : nil
 #      render :partial => 'form', :object => @story, :locals => { :no_refresh => true, :edit => false, :project => @project }, :status => :internal_server_error
 #    end
 #  end
 # 
 #  # PUT /stories/1
 #  def update
 #    @story = Story.find(params[:id])
 #    if @story.update_attributes(params[:story])
 #      render :inline => "<script>location.reload(true);</script>", :status => :ok
 #    else
 #      render :partial => 'form', :object => @story, :locals => { :no_refresh => true, :edit => true, :project => @story.project_id }, :status => :internal_server_error
 #    end
 # end
 # 
 #  # DELETE /stories/1
 #  def destroy
 #    @story = Story.find(params[:id])
 #    if @story.destroy
 #      render :inline => "<script>location.reload(true);</script>", :status => :ok
 #    else
 #      render :inline => "", :status => :internal_server_error
 #    end
 #  end
 # 
 #  def edit_priority
 #    @story = Story.find(params[:id])
 #    render :partial => "edit_priority", :locals => {:story => @story }
 #  end
 # 
 #  def update_priority
 #    @story = Story.find(params[:story_id])
 #    @story.update_attributes(params[:story])
 #    render :inline => "<script>location.reload(true);</script>"
 #  end
 # 
 #  def start_story
 #    @story = Story.find(params[:id])
 #    @story.start
 #    redirect_to :controller => :backlog, :action => (params[:project]) ? :index : :team, :id => (params[:project]) ? params[:project] : params[:team], :project_id => params[:project_id]
 #  end
 # 
 #  def stop_story
 #    @story = Story.find(params[:id])
 #    @story.stop
 #    redirect_to :controller => :backlog, :action => (params[:project]) ? :index : :team, :id => (params[:project]) ? params[:project] : params[:team], :project_id => params[:project_id]
 #  end
 # 
 #  def finish_story
 #    @story = Story.find(params[:id])
 #    @story.finish
 #    redirect_to :controller => :backlog, :action => (params[:project]) ? :index : :team, :id => (params[:project]) ? params[:project] : params[:team], :project_id => params[:project_id]
 #  end
 # 
  # def tasks_by_status
  #   @story = Story.find(params[:id])
  #   @status = params[:status]
  #   case @status
  #     when "in_progress"
  #       @tasks = @story.tasks.in_progress
  #     when "not_started"
  #       @tasks = @story.tasks.not_started
  #     when "finished"
  #       @tasks = @story.tasks.finished
  #     else
  #       @tasks = []
  #   end
  # end
  def find_story
    @story = @project.stories.find(params[:id])
  end
end
