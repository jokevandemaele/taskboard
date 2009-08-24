class BacklogController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions
  def show
      @view = 'project'
      @project = Project.find(params[:id])
      @stories = @project.stories_by_priority
      @projects = [@project]

      @member = @current_member
      @member.last_project = @project
      @member.save

      @member_team = @project.teams.first
      @project.teams.each do |team|
        @member_team = team if(team.members.include?(@member))
      end
  end

  def team
      @view = 'team'
      @member_team = Team.find(params[:id])
      @projects = @member_team.projects
      @stories = []
      @projects.each do |project|
        project.stories.each { |story| @stories << story }
      end
      @stories = @stories.sort_by {|story| story.priority }
      @stories = @stories.reverse
  end

end
