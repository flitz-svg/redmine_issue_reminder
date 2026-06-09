namespace :redmine do
  namespace :issue_reminder do
    desc "Envía recordatorios automáticos a usuarios con tickets sin actividad según la configuración del plugin"
    task send: :environment do
      puts "[IssueReminder] #{Time.now} — iniciando..."

      # Leer configuración guardada en el panel de Automatización
      settings = Setting.plugin_redmine_issue_reminder rescue {}

      unless settings['auto_enabled'] == '1'
        puts "[IssueReminder] Recordatorios automáticos desactivados. Saliendo."
        next
      end

      days        = [(settings['auto_days'] || '1').to_i, 1].max
      project_ids = Array(settings['auto_project_ids']).map(&:to_i).reject(&:zero?)
      status_ids  = Array(settings['auto_status_ids']).map(&:to_i).reject(&:zero?)

      puts "[IssueReminder] Configuración: días=#{days}, proyectos=#{project_ids.any? ? project_ids.join(',') : 'todos'}, estados=#{status_ids.any? ? status_ids.join(',') : 'todos'}"

      scope = Issue.open
                   .where.not(assigned_to_id: nil)
                   .where('issues.updated_on <= ?', days.days.ago)
                   .includes(:assigned_to, :status, :project, :journals)
      scope = scope.where(project_id: project_ids) if project_ids.any?
      scope = scope.where(status_id: status_ids)   if status_ids.any?

      issues_by_user = Hash.new { |h, k| h[k] = [] }
      scope.find_each do |issue|
        user = issue.assigned_to
        next unless user.is_a?(User) && user.active? && user.mail.present?
        issues_by_user[user] << issue
      end

      if issues_by_user.empty?
        puts "[IssueReminder] Sin tickets que cumplan el criterio (#{days} día(s) sin actividad)."
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
