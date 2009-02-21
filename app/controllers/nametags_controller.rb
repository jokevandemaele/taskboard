class NametagsController < ApplicationController
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
end
