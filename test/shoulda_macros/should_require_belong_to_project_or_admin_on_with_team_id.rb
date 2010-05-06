module RequireBelongToProjectOrAdmiOnWithTeamId
  def should_require_belong_to_project_or_admin_on_with_team_id(actions = [])
    if actions == :all
      actions = %w{team}.map(&:to_sym)
    else
      actions = Array(actions)
    end

    action_methods = {
      :team  => :get
    }

    context "A not logged in user" do
      setup do
        @user = not_logged_user
        @project = Factory(:project)
        @team = @project.teams.first
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action}" do
          setup do
            send(method, action, :team_id => @team.to_param)
          end

          should_set_the_flash_to("Please Login")
          should_redirect_to('the login page') { login_url }
        end
      end
    end

    context "If I'm a normal user accessing a project i don't belong to" do
      setup do
        @organization = Factory(:organization)
        @team = @organization.teams.first
        @project = @organization.projects.first
        @user = Factory(:user)
        @admin = Factory(:user)
        @admin.add_to_organization(@organization)
        @organization.reload
        @user.add_to_organization(@organization)
        @team.users.delete(@user)
        assert !@project.users.include?(@user)
        assert !@user.admins?(@organization)
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action}" do
          setup do
            send(method, action, :team_id => @team.to_param, :id => 1)
          end

          should_set_the_flash_to("Access Denied")
          should_redirect_to('the root page') { root_url }
        end
      end
    end

  end
end

class ActiveSupport::TestCase
  extend RequireBelongToProjectOrAdmiOnWithTeamId
end


