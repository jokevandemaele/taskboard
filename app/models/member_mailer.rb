class MemberMailer < ActionMailer::Base

  def invite(sent_at = Time.now)
    subject    'MemberMailer#invite'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def create(member, sent_at = Time.now)
    subject     'Welcome to the Agilar Taskboard!'
    recipients  member.email
    from        %("Agilar Taskboard" <taskboard@agilar.org>)
    sent_on     sent_at
    
    body        :member => member
  end

  def add_guest_to_projects(member, added_by, projects, sent_at = Time.now)
    subject     'You have been added as a guest member'
    recipients  member.email
    from        %("Agilar Taskboard" <taskboard@agilar.org>)
    sent_on     sent_at

    project_names = []
    projects.each { |project| project_names << Project.find(project).name }

    body :member => member, :added_by => added_by, :projects => project_names
  end

end
