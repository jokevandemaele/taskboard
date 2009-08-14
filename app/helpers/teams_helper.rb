module TeamsHelper
  def options_for_team_select(teams)
    output = ''
    teams.each do |team|
      output += "<option value=\"#{team.id}\">#{team.name} (#{team.organization.name})</option>"
    end
    return output
  end

end
