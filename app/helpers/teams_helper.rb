module TeamsHelper
  def options_for_project_select(projects)
    output = ''
    projects.each do |project|
      output += "<option value=\"#{project.id}\">#{project.name} (#{project.organization.name})</option>"
    end
    return output
  end

end
