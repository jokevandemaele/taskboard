class OrganizationsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions, :except => [:index]
  
  def index
    @member = session[:member]
    if @member.admin?
      @organizations = Organization.all
    else
      @organizations = @member.organizations    
    end
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

  def add_project_form
    @projects = Project.free
    @organization = Organization.find(params[:organization])
    render :update do |page|
    		page.replace_html "dummy-for-actions", 
    			:partial => 'add_project_form', 
    			:locals => { :organization => @organization, :projects =>  @projects	}
    end
  end
  
  def add_project
    @organization = Organization.find(params[:organization][:id])
    if params[:organization][:projects]
      @project = Project.find(params[:organization][:projects])
      @organization.projects << @project
      if @organization.save
        render :update do |page|
          page.replace_html "dummy-for-actions", "<script>location.reload(true)</script>"
        end
      end
    end
  end
  
  def remove_project
    @project = Project.find(params[:project])
    @organization = Organization.find(params[:organization])
    
    @organization.projects.delete @project
    if @organization.save
      render :update do |page|
        page.replace_html "dummy-for-actions", "<script>location.reload(true)</script>"
      end
    end
  end


  def add_member_form
    @organization = Organization.find(params[:organization])
    @members = Member.all - @organization.members
    render :update do |page|
    		page.replace_html "dummy-for-actions", 
    			:partial => 'add_member_form', 
    			:locals => { :organization => @organization, :members =>  @members	}
    end
  end
  
  def add_member
    @organization = Organization.find(params[:organization][:id])
    
    if params[:organization][:members]
      @member = Member.find(params[:organization][:members])
      @membership = OrganizationMembership.new
      @membership.member = @member
      @membership.organization = @organization
      @membership.admin = nil
      
      if @membership.save
        render :update do |page|
          page.replace_html "dummy-for-actions", "<script>location.reload(true)</script>"
        end
      end
    end
  end
  
  def remove_member
    # TODO: This leaves the membership in the database, only removes the organization, see if there is a way to enhance this
    @organization = Organization.find params[:organization]
    @membership = OrganizationMembership.first(:conditions => ["member_id = ? and organization_id = ?", params[:member], params[:organization]])
    @membership.destroy
    render :update do |page|
      page.replace_html "dummy-for-actions", "<script>location.reload(true)</script>"
    end
  end
  
  def remove_admin
    @membership = OrganizationMembership.find(params[:membership])
    @membership.admin = nil
    @membership.save
    render :update do |page|
      page.replace_html "dummy-for-actions", "<script>location.reload(true)</script>"
    end
    
  end
  
  def make_admin
    @membership = OrganizationMembership.find(params[:membership])
    logger.error(@membership.inspect)
    @membership.admin = true
    @membership.save
    render :update do |page|
      page.replace_html "dummy-for-actions", "<script>location.reload(true)</script>"
    end
    
  end

end
