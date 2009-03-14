class MembersController < ApplicationController
  #before_filter :login_required, :except => [:login, :logout]

  # GET /members
  # GET /members.xml
  def index
    @members = Member.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
    end
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/new
  # GET /members/new.xml
  def new
    @member = Member.new
    @team = params[:team] if params[:team]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.xml
  def create
    @member = Member.new(params[:member])
  
    if(params[:dynamic])
      @member.save
      render :inline => "<script>location.reload(true);</script>"
    else
      respond_to do |format|
        if @member.save
          flash[:notice] = 'Member was successfully created.'
          format.html { redirect_to(@member) }
          format.xml  { render :xml => @member, :status => :created, :location => @member }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])
    if(params[:dynamic])
      @member.update_attributes(params[:member])
      if @member.save
        render :inline => "<script>location.reload(true);</script>"
      else
        flash[:notice] = "Username Already Taken"
        render :inline => "<script>location.reload(true);</script>"
      end
    else
      respond_to do |format|
        if @member.update_attributes(params[:member])
          flash[:notice] = 'Member was successfully updated.'
          format.html { redirect_to(@member) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end

  def show_form
    if(params[:member])
	    @member = Member.find(params[:member])
    else
	    @member = Member.new
    end

    render :update do |page|
	    page.replace_html "dummy-for-actions", :partial => 'form', :locals => { :member => @member }
    end
  end
  
  def login
    if request.post?
      session[:member] = Member.authenticate(params[:member][:username], params[:member][:password])
      if session[:member]
        redirect_to_stored
      else
        flash[:notice] = "Access Denied"
      end
    end
  end

  def logout
    session[:member] = nil
    if(request.referer)
      redirect_to(request.referer)
    else
      redirect_to(projects_url)
    end
  end
end

