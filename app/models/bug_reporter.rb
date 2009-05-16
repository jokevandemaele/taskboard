class BugReporter < ActionMailer::Base
  

  def bug_report(subject, message, member, sent_at = Time.now)
    subject    "[TASKBOARD-BUG-REPORT] From: #{member} - #{subject}"
    recipients 'taskboard@agilar.org'
    from       'taskboard@agilar.org'
    sent_on    sent_at
    
    body       :message => message
  end

end
