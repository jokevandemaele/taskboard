class UserMailer < ActionMailer::Base

  def create(user, sent_at = Time.now)
    subject     Configuration['emails']['new_user']['subject']
    recipients  user.email
    from        %("#{Configuration['emails']['new_user']['from_name']}" <#{Configuration['emails']['new_user']['from_email']}>)
    sent_on     sent_at

    body        :user => user
  end

  def add_guest_to_projects(member, added_by, projects, sent_at = Time.now)
    subject     'You have been added as a guest member'
    recipients  member.email
    from        %("Agilar Taskboard" <info@agilar.org>)
    sent_on     sent_at

    project_names = []
    projects.each { |project| project_names << Project.find(project).name }

    body :member => member, :added_by => added_by, :projects => project_names
  end

end
