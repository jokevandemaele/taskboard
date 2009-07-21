class MemberMailer < ActionMailer::Base

  def invite(sent_at = Time.now)
    subject    'MemberMailer#invite'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def create(member, password, creator, sent_at = Time.now)
    subject    'Welcome to the Agilar Taskboard!'
    recipients member.email
    from       'taskboard@agilar.org'
    sent_on    sent_at
    
    body       :member => member, :password => password, :creator => creator
  end

end
