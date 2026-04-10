class IssueReminderMailer < ActionMailer::Base
  include Redmine::I18n
  helper { include Redmine::I18n }

  def reminder_email(user, issues)
    @user   = user
    @issues = issues
    mail(
      to:      user.mail,
      from:    Setting.mail_from,
      subject: l(:ir_mail_subject, count: issues.size)
    )
  end
end
