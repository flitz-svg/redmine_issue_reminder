namespace :redmine do
  namespace :issue_reminder do
    desc "Envía recordatorios automáticos diarios a usuarios con tickets abiertos"
    task send: :environment do
      puts "[IssueReminder] #{Time.now} — iniciando..."

      issues_by_user = Hash.new { |h, k| h[k] = [] }

      Issue.open
           .where.not(assigned_to_id: nil)
           .includes(:assigned_to, :status, :project, :journals)
           .find_each do |issue|
        user = issue.assigned_to
        next unless user.is_a?(User) && user.active? && user.mail.present?
        issues_by_user[user] << issue
      end

      if issues_by_user.empty?
        puts "[IssueReminder] Sin tickets abiertos asignados."
        next
      end

      sent = 0
      issues_by_user.each do |user, user_issues|
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
