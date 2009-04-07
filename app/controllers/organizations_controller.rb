class OrganizationsController < ApplicationController
  before_filter :login_required

  def index
    @organizations = Organization.find(:all)
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def new
    @organization = Organization.new
    @free_projects = Project.free
  end

  def edit
    @organization = Organization.find(params[:id])
    @free_projects = Project.free
  end

  def create
    @organization = Organization.new(params[:organization])

    if @organization.save
      render :inline => "<script>location.reload(true)</script>"
    else
      render :action => "new"
    end
  end

  def update
    @organization = Organization.find(params[:id])

    if @organization.update_attributes(params[:organization])
      flash[:notice] = 'Organization was successfully updated.'
      redirect_to(@organization)
    else
      render :action => "edit"
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    redirect_to(organizations_url)
  end
  
  def show_form
    if(params[:organization])
	    @organization = Organization.find(params[:organization])
    else
	    @organization = Organization.new
    end
    
    @projects = Project.free

    render :update do |page|
    		page.replace_html "dummy-for-actions", 
    			:partial => 'form', 
    			:object => @organization,
    			:locals => { :projects =>  @projects	}
    end
  end
  
  def add_project
    render :update do |page|
    		page.insert_html "selected-projects", "<p>#{params[:organization]}</p>"
    end
  end
end
