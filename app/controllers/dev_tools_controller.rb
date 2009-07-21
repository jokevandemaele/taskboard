class DevToolsController < ApplicationController
  def consistency_checker
    # To check memberships
    @memberships = OrganizationMembership.all
    # To check projects
    @projects = Project.all
    # To check teams
    @teams = Team.all
    # To check tasks
    @tasks = Task.all
    # To check nametags
    @nametags = Nametag.all
    # To check statustags
    @statustags = Statustag.all
    # To check stories
    @stories = Story.all
  end
end
