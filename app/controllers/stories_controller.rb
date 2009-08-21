class StoriesController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # GET /stories/1
  def show
    @story = Story.find(params[:id])
  end

  # GET /stories/new
  def new
	  @story = Story.new
    @project = (params[:project]) ? params[:project] : nil
    @projects = Team.find(params[:team]).projects
    @last_realid = (params[:project]) ? Story.last_realid(@project) : nil
    render :partial => 'form', :object => @story, :locals => { :edit => false, :project =>  @project, :last_realid => @last_realid}, :status => :ok
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
    render :partial => 'form', :object => @story, :locals => { :edit => true, :project => @story.project.id }, :status => :ok
  end

  # POST /stories
  def create
    @story = Story.new(params[:story])
    @story.priority = 0 if !@story.priority
    if @story.save
      render :inline => "<script>location.reload(true);</script>", :status => :created
    else
      @last_realid = (@story.project_id) ? Story.last_realid(@story.project_id) : nil
      @project = (@story.project_id) ? @story.project_id : nil
      render :partial => 'form', :object => @story, :locals => { :no_refresh => true, :edit => false, :project => @project, :last_realid => @last_realid }, :status => :internal_server_error
    end
  end

  # PUT /stories/1
  def update
    @story = Story.find(params[:id])
	  if @story.update_attributes(params[:story])
      render :inline => "<script>location.reload(true);</script>", :status => :ok
    else
      render :partial => 'form', :object => @story, :locals => { :no_refresh => true, :edit => true, :project => @story.project_id }, :status => :internal_server_error
    end
 end

  # DELETE /stories/1
  def destroy
    @story = Story.find(params[:id])
    if @story.destroy
      render :inline => "<script>location.reload(true);</script>", :status => :ok
    else
      render :inline => "", :status => :internal_server_error
    end
  end

  def start_story
    @story = Story.find(params[:id])
    @story.status = 'in_progress'
    @story.save
    redirect_to :controller => :backlog, :action => (params[:project]) ? :show : :team, :id => (params[:project]) ? params[:project] : params[:team]
  end

  def edit_priority
	  @story = Story.find(params[:id])
    render :partial => "edit_priority", :locals => {:story => @story }
  end

  def update_priority
  	@story = Story.find(params[:story_id])
  	@story.update_attributes(params[:story])
    render :inline => "<script>location.reload(true);</script>"
  end

  def stop_story
    @story = Story.find(params[:id])
    @story.status = 'not_started'
    if params[:priority]
      @story.priority = params[:priority]
    end
    @story.save
    redirect_to :controller => :backlog, :action => (params[:project]) ? :show : :team, :id => (params[:project]) ? params[:project] : params[:team]
  end

  def finish_story
    @story = Story.find(params[:id])
    @story.status = 'finished'
    @story.priority = -1
    @story.save
    redirect_to :controller => :backlog, :action => (params[:project]) ? :show : :team, :id => (params[:project]) ? params[:project] : params[:team]
  end
end
