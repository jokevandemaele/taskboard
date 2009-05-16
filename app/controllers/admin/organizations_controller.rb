class Admin::OrganizationsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions, :except => [:index]
  #layout proc{ |controller| controller.request.path_parameters[:action] == 'show' ? nil : "admin/organizations" }
  
  def index
    @member = Member.find session[:member]
    
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
      render :update, :status => :ok do |page|
        page.insert_html :bottom, "organizations-list", :partial => "organization", :object => @organization
        page.replace_html "dummy-for-actions", "<script>$('dialog-background-fade').hide();</script>"
      end
      #render :partial => "organization", :object => @organization, :locals => { :close_dialog => 'form-add-organization' }, :status => :ok
    else
      # Decide what to do here, we should send the error somehow and process it in the view.
      render :update, :status => :internal_server_error do |page|
      		page.replace_html "dummy-for-actions", 
      		:partial => 'form',
      		:object => @organization,
      		:locals => { :no_refresh => true }
      end
      
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
    if @organization.destroy
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :internal_server_error
    end
  end
  
  def show_form
    @edit = false
    if(params[:id])
	    @organization = Organization.find(params[:id])
	    @edit = true
    else
	    @organization = Organization.new
    end
    
    render :update do |page|
    		page.replace_html "dummy-for-actions", 
    		:partial => 'form',
    		:object => @organization,
    		:locals => { :edit => @edit }
    end
  end

  def add_project_form
    @projects = Project.free
    logger.error("Projects: ?",@projects)
    @organization = Organization.find(params[:id])
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
    @organization = Organization.find params[:organization]
    @membership = OrganizationMembership.first(:conditions => ["member_id = ? and organization_id = ?", params[:member], params[:organization]])
    @member = @membership.member
    # We assume that the team has only one project, that's why .first is enough and we don't have to iterate.
    @member.teams.each { |team| team.members.delete(@member) if team.projects.first.organization == @organization }
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
