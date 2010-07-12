class StoriesController < ApplicationController
  before_filter :require_user, :except => [:tasks_by_status]
  before_filter :require_belong_to_project_or_team_or_admin, :except => [:tasks_by_status]
  before_filter :require_belong_to_project_or_auth_guest, :only => [:tasks_by_status]
  before_filter :find_story, :only => [ :edit, :update, :destroy, :start, :stop, :finish, :update_priority, :update_size ]
  layout nil

  # GET /projects/:project_id/stories
  def index
    @stories = @project.stories
    render :json => @stories, :status => :ok
  end
  
  # GET /projects/:project_id/stories/new
  def new
    @story = (params[:team_id].blank?) ? @project.stories.build : Story.new
    @projects = @team.projects if !params[:team_id].blank?
    @default_realid = @project ? @project.next_realid : @team.projects.first.next_realid
    @default_priority = @project ? @project.next_priority : @team.next_priority
  end
  
  # POST /projects/:project_id/stories
  def create
    @project = Project.find(params[:story][:project_id]) if (!params[:team_id].blank?)
    @story = @project.stories.build(params[:story])
    # Don't know why but this is not setting the id and priority automatically
    @story.realid = @project.next_realid if !@story.realid
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
    @story.save
    render :inline => @story.priority, :status => :ok
  end

  # POST /projects/:project_id/stories/:id/update_size
  def update_size
    @story.size = params[:value]
    @story.save
    render :inline => @story.size, :status => :ok
  end

  def tasks_by_status
    @story = Story.find(params[:id])
    @status = params[:status]
    case @status
      when "in_progress"
        @tasks = @story.tasks.in_progress
      when "not_started"
        @tasks = @story.tasks.not_started
      when "finished"
        @tasks = @story.tasks.finished
      else
        @tasks = []
    end
  end
  def find_story
    @story = @project.stories.find(params[:id])
  end
end
