class BugReporter < ActionMailer::Base

  def bug_report(subject, message, user, sent_at = Time.now)
    subject    "#{Configuration['emails']['bug_report']['subject']} From: #{user.name} <#{user.email}> - #{subject}"
    recipients  %("#{Configuration['emails']['bug_report']['to_name']}" <#{Configuration['emails']['bug_report']['to_email']}>)
    from        %("#{Configuration['emails']['bug_report']['from_name']}" <#{Configuration['emails']['bug_report']['from_email']}>)
    sent_on    sent_at
    
    body       :message => message
  end

end
