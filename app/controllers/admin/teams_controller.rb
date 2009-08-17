class Admin::TeamsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  # GET /teams
  # def index
  #   @organizations = current_member.organizations_administered
  #   @teams = []
  #   @organizations.each do |organization|
  #     organization.teams.each { |team| @teams << team }
  #   end
  # end

  # GET /teams/1
  def show
    @team = Team.find(params[:id])
  end

  # GET /teams/new
  def new
    @team = Team.new
    @organization = Organization.find(params[:organization])
    render :partial => 'form', :object => @team, :locals => { :edit => false, :organization =>  @organization }, :status => :ok
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
    render :partial => 'form', :object => @team, :locals => { :edit => true }, :status => :ok
  end

  # POST /teams
  def create
    @team = Team.new(params[:team])

    if @team.save
      render :inline => "<script>location.reload(true);</script>", :status => :created
    else
      @organization = Organization.find(params[:team][:organization])
      render :partial => 'form',
      		:object => @team,
      		:locals => { :no_refresh => true, :edit => false, :organization =>  @organization },
 		      :status => :internal_server_error
    end
  end

  # PUT /teams/1
  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      render :inline => "<script>location.reload(true);</script>", :status => :ok
    else
      @organization = Organization.find(params[:organization])
      render :partial => 'form',
      		:object => @team,
      		:locals => { :no_refresh => true, :edit => true, :organization =>  @organization },
 		:status => :internal_server_error
    end
  end

  # DELETE /teams/1
  def destroy
    @team = Team.find(params[:id])
    if @team.destroy
      render :inline => "", :status => :ok
    else
      render :inline => "", :status => :internal_server_error
    end

  end

  def add_member
    @team = Team.find(params[:team])
    @member = Member.find(params[:member])
    if !@team.members.exists?(@member)
      @team.members << @member
      @team.save
    end
    render :update do |page|
      page.replace_html "team_members_list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }
      # For some obscure reason, @team seems to be nil at this point.
      @team = Team.find(params[:team])
      page.replace_html "members-list", :partial => "members_list", :locals => { :members => @team.projects.first.organization.members, :project => params[:project] }
    end
  end

  def remove_member
    @team = Team.find(params[:team])
    @member = Member.find(params[:member])
    if @team.members.exists?(@member)
      @team.members.delete(@member)
      @team.save
    end
    render :update do |page|
      page.replace_html "team_members_list-#{@team.id}", :partial => 'team_members_list', :locals => { :team => @team }
    end
  end
end
