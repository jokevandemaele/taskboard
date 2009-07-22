class Admin::MembersController < ApplicationController
  before_filter :login_required, :except => [:login, :logout]
  before_filter :check_permissions, :except => [:login, :logout, :access_denied, :report_bug]
  layout 'admin/members', :except => [:report_bug, :login]
  
  # GET /members
  def index
    @members = Member.find(:all)
    @hide_sidebar = nil
  end

  # # GET /members/1
  # def show
  # end

  # GET /members/new
  def new
    @member = Member.new

    if params[:organization]
      @organization = Organization.find(params[:organization])
      @members_not_in_organization = Member.all - @organization.members
    else
      @organization = nil
    end
    
    render :partial => 'form', :object => @member, :locals => { :project => params[:project], :edit => false }, :status => :ok
  end

  # GET /members/1/edit
   def edit
     @member = Member.find(params[:id])
     render :partial => 'form', :object => @member, :locals => { :project => params[:project], :edit => true }
   end

  # POST /members
  def create
    # See how to move this to ajax
    @params = params
    @member = Member.new(@params[:member])


    if @member.save
      @member.add_picture(@params[:picture_file])
      @member.add_to_organization(@params[:organization])
      # Send email notificating the lucky user
      MemberMailer.deliver_create(@member, @params[:member][:password], @current_member.name)
      render :inline => "<script>top.location.reload(true)</script>", :status => :created
    else
      render :partial => "user_form_error", :locals => { :object => @member }, :status => :bad_request
    end
  end

  # PUT /members/1
  def update
    @member = Member.find(params[:id])
    if !params[:member][:admin]
      params[:member][:admin] = nil
    end

    if params[:member][:password].empty?
      old_password = @member.hashed_password
    end
    
    @member.update_attributes(params[:member])
    
    if params[:member][:password].empty?
      @member.hashed_password = old_password
    end
    
    if @member.save
      @member.add_picture(params[:picture_file])
      render :inline => "<script>top.location.reload(true)</script>", :status => :ok
    else
      render :partial => "user_form_error", :locals => { :object => @member }, :status => :bad_request
    end
  end

  # DELETE /members/1
  def destroy
    @member = Member.find(params[:id])
    if @member.destroy
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :bad_request
    end
  end

  def login
    flash[:notice] = nil
    if request.post?
      @member = Member.authenticate(params[:member][:username], params[:member][:password])
      
      if @member
        session[:member] = @member.id
        redirect_to_stored
      else
        flash[:notice] = "Access Denied"
      end
    end
  end

  def logout
    session[:member] = nil
    session[:return_to] = nil
    redirect_to :controller => 'admin/members', :action => 'login'
  end

  def access_denied
    @hide_sidebar = true
    @current_member = Member.find(session[:member])
    render :template => "admin/members/access_denied", :status => :forbidden
  end
  
  # def delete_member
  #   @member = Member.find(params[:id])
  #   @member.destroy
  #   @members = Member.all()
  #   
  #   render :update do |page| 
  #     page.replace_html "members-list", :partial => "teams/members_list", :locals => { :members => @members, :project => params[:project] }
  #   end
  # end
  # 
  # def make_sysadmin
  #   @member = Member.find(params[:id])
  #   @member.admin = true
  #   @member.save
  #   render :update do |page|
  #     page.replace_html "dummy-for-actions", "<script>location.reload(true)</script>"
  #   end
  # end
  # 
  # def remove_sysadmin
  #   @member = Member.find(params[:id])
  #   @member.admin = nil
  #   @member.save
  #   render :update do |page|
  #     page.replace_html "dummy-for-actions", "<script>location.reload(true)</script>"
  #   end
  # end

  def report_bug
    @member = Member.find(current_member)
    if request.get?
      session[:return_to] = request.referer
    end
    if request.post?
      BugReporter.deliver_bug_report(params[:subject], params[:message], @member.name)
      redirect_to_stored
    end
  end
end
