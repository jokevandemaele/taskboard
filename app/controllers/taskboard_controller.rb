class TaskboardController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  
  def show
    @project = Project.find(params[:id])
    @stories_by_priority = @project.stories_in_progress
    @member = @current_member

    @project.teams.each do |team|
      if(team.members.include?(@member))
        @member_team = team
      end
    end
    if(@member_team)
      @color = @member_team.color
    else
      @color = "3771c8"
      @member_team = @project.teams.first
    end
  end
end
