class IssueReminderMailer < ActionMailer::Base
  include Redmine::I18n
  layout 'mailer'

  def reminder_email(user, issues)
    @user   = user
    @issues = issues
    mail(
      to:      user.mail,
      from:    Setting.mail_from,
      subject: "[Recordatorio] Tienes #{issues.size} ticket(s) asignado(s) pendiente(s)"
    )
  end
end
