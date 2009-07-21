class MemberMailer < ActionMailer::Base
  

  def invite(sent_at = Time.now)
    subject    'MemberMailer#invite'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def create(sent_at = Time.now)
    subject    'MemberMailer#create'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
