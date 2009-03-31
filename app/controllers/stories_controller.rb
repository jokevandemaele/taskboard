class StoriesController < ApplicationController
  before_filter :login_required

  # GET /stories
  def index
    @stories = Story.find(:all)
  end

  # GET /stories/1
  def show
    @story = Story.find(params[:id])
  end

  # GET /stories/new
  def new
    @story = Story.new
    if params[:project]
      @project = Project.find(params[:project])
      @last_realid = Story.last_realid(@project.id)
    else
      @projects = Project.find(:all).collect { |project| [project.name, project.id] }
    end 
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
  end

  # POST /stories
  def create
    @story = Story.new(params[:story])
    @project = Project.find(params[:project_id])
    @story.project = @project
    if(params[:dynamic])
	    if(!@story.save)
	      render :inline => "Error #{@story.errors.inspect}"
      else
        render :inline => "<script>location.reload(true);</script>"
      end
    else
      if @story.save
        redirect_to(:controller => :projects, :action => :show , :id => @story.project_id)
      else
        render :action => "new"
      end
    end
  end

  # PUT /stories/1
  def update
    @story = Story.find(params[:id])

    if(params[:dynamic])
	    @story.update_attributes(params[:story])
	    render :inline => "<script>location.reload(true);</script>"
    else
      if @story.update_attributes(params[:story])
        redirect_to(@story)
      else
        render :action => "edit"
      end
    end 
 end

  # DELETE /stories/1
  def destroy
    @story = Story.find(params[:id])
    @story.destroy
    if(params[:dynamic])
      render :inline => "<script>location.reload(true);</script>"
    else
      redirect_to(stories_url)
    end
  end

  def start_story
    @story = Story.find(params[:id])
    @story.status = 'in_progress'
    @story.save
    
    redirect_to :controller => :backlog, :action => :show, :id => params[:project]
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
    redirect_to :controller => :backlog, :action => :show, :id => params[:project]
  end

  def finish_story
    @story = Story.find(params[:id])
    @story.status = 'finished'
    @story.priority = -1
    @story.save
    redirect_to :controller => :backlog, :action => :show, :id => params[:project]
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
