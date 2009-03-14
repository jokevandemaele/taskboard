class StoriesController < ApplicationController
  #before_filter :login_required
  # GET /stories
  # GET /stories.xml
  def index
    @stories = Story.find(:all)
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.xml
  def new
    @story = Story.new
    if params[:project]
      @project = Project.find(params[:project])
      @last_realid = Story.last_realid(@project.id)
    else
      @projects = Project.find(:all).collect { |project| [project.name, project.id] }
    end 

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
  end

  # POST /stories
  # POST /stories.xml
  def create
    @story = Story.new(params[:story])
    @project = Project.find(params[:project_id])
    @story.project = @project
    if(params[:dynamic])
	    @story.save
	    render :inline => "<script>location.reload(true);</script>"
    else
	    respond_to do |format|
	      if @story.save
		flash[:notice] = "Story was successfully created. #{@project.inspect}"
		format.html { redirect_to(:controller => :projects, :action => :show , :id => @story.project_id) }
		format.xml  { render :xml => @story, :status => :created, :location => @story }
	      else
		format.html { render :action => "new" }
		format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
	      end
	    end
    end 
 end

  # PUT /stories/1
  # PUT /stories/1.xml
  def update
    @story = Story.find(params[:id])

    if(params[:dynamic])
	    @story.update_attributes(params[:story])
	    render :inline => "<script>location.reload(true);</script>"
    else
	    respond_to do |format|
	      if @story.update_attributes(params[:story])
		flash[:notice] = 'Story was successfully updated.'
		format.html { redirect_to(@story) }
		format.xml  { head :ok }
	      else
		format.html { render :action => "edit" }
		format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
	      end
	    end
    end 
 end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to(stories_url) }
      format.xml  { head :ok }
    end
  end

  def start_story
    @story = Story.find(params[:id])
    @story.status = 'in_progress'
    @story.save
    respond_to do |format|
      format.html { redirect_to :controller => 'backlog', :project => params[:project]}
      format.xml  { head :ok }
    end
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
    respond_to do |format|
      format.html { redirect_to :controller => 'backlog', :project => params[:project]}
      format.xml  { head :ok }
    end
  end

  def finish_story
    @story = Story.find(params[:id])
    @story.status = 'finished'
    @story.priority = -1
    @story.save
    respond_to do |format|
      format.html { redirect_to :controller => 'backlog', :project => params[:project]}
      format.xml  { head :ok }
    end
  end

  def show_form
    if(params[:story])
	@story = Story.find(params[:story])
    else
	@story = Story.new
    end
    @project = Project.find(params[:project])
    @last_realid = Story.last_realid(@project.id)

    render :update do |page|
      page.replace_html "dummy-for-actions", :partial => 'form', :locals => { :story => @story, :project =>  @project }
    end
  end

end
