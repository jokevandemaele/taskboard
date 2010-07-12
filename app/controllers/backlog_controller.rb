class BacklogController < ApplicationController
  before_filter :require_user
  before_filter :require_belong_to_project_or_admin, :only => :index
  before_filter :require_belong_to_team, :only => :team
  before_filter :require_belong_to_project_or_team_or_admin, :only => :export
  layout :set_layout
  def index
      @view = :project
      @project = Project.find(params[:project_id])
      @stories = @project.stories
      @projects = [@project]

      @member = current_user
      @member.last_project = @project
      @member.save

      @team = @project.team_including(@member)
  end

  def team
      @view = :team
      @team = Team.find(params[:team_id])
      @projects = @team.projects
      @stories = @team.stories
   end
   
   def export
     @object = params[:team_id].blank? ? Project.find(params[:project_id]) : Team.find(params[:team_id])
     headers['Content-Type'] = "application/vnd.ms-excel"
     headers['Content-Disposition'] = "attachment; filename=\"#{@object.name.to_param}_backlog_export_#{Time.now.to_param}.xls\""
     headers['Cache-Control'] = ''
     @view = :export
     @stories = @object.stories
   end
   private
   def set_layout
     (request.path_parameters["action"] == "export") ? nil : 'backlog'
   end
end
