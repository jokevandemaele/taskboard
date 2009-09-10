class BugReporter < ActionMailer::Base

  def bug_report(subject, message, member, sent_at = Time.now)
    subject    "[TASKBOARD-BUG-REPORT] From: #{member} - #{subject}"
    recipients 'agilar-dev-team@googlegroups.com'
    from       'taskboard@agilar.org'
    sent_on    sent_at
    
    body       :message => message
  end

end
