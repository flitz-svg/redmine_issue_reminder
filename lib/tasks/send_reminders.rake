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

      days             = [(settings['auto_days'] || '1').to_i, 1].max
      project_ids      = Array(settings['auto_project_ids']).map(&:to_i).reject(&:zero?)
      status_ids       = Array(settings['auto_status_ids']).map(&:to_i).reject(&:zero?)

      puts "[IssueReminder] Configuración: días=#{days}, proyectos=#{project_ids.any? ? project_ids.join(',') : 'todos'}, estados=#{status_ids.any? ? status_ids.join(',') : 'todos'}"

      scope = Issue.open
                   .where.not(assigned_to_id: nil)
                   .where('issues.updated_on <= ?', days.days.ago)
                   .includes(:assi