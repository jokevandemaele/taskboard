class MemberMailer < ActionMailer::Base

  def invite(sent_at = Time.now)
    subject    'MemberMailer#invite'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def create(username, email, sent_at = Time.now)
    subject    'Welcome to the Agilar Taskboard!'
    recipients email
    from       'taskboard@agilar.org'
    sent_on    sent_at
    
    body       :username => username
  end

end
