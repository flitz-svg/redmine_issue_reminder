namespace :redmine do
  namespace :issue_reminder do
    desc "Envía recordatorios automáticos diarios a usuarios con tickets abiertos"
    task send: :environment do
      puts "[IssueReminder] #{Time.now} — iniciando..."
      issues = Issue.open
                    .includes(:assigned_to, :status, :project, :journals)
                    .where.not(assigned_to_id: nil)
                    .order('issues.updated_on ASC')
      if issues.empty?
        puts "[IssueReminder] Sin tickets abiertos asignados."; next
      end
      sent = 0
      issues.group_by(&:assigned_to).each do |user, user_issues|
        unless user.is_a?(User) && user.active? && user.mail.present?
          puts "[IssueReminder] Saltando #{user&.id}"; next
        end
        begin
          IssueReminderMailer.reminder_email(user, user_issues).deliver_now
          puts "[IssueReminder] ✓ #{user.mail} — #{user_issues.size} ticket(s)"
          sent += 1
        rescue => e
          puts "[IssueReminder] ✗ #{user.mail}: #{e.message}"
        end
      end
      puts "[IssueReminder] Finalizado. Enviados: #{sent}"
    end
  end
end
