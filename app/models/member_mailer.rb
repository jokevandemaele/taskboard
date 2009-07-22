class MemberMailer < ActionMailer::Base

  def invite(sent_at = Time.now)
    subject    'MemberMailer#invite'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def create(member, password, creator, url, sent_at = Time.now)
    subject    'Welcome to the Agilar Taskboard!'
    recipients member.email
    from       'Agilar Taskboard Team <no-reply@agilar.org>'
    sent_on    sent_at
    
    body       :member => member, :password => password, :creator => creator, :url => url
  end

end
