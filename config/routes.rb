RedmineApp::Application.routes.draw do
  # Panel de administración
  scope '/admin' do
    get  'issue_reminders',      to: 'issue_reminders#index',          as: :redmine_ir_panel
    post 'issue_reminders/send', to: 'issue_reminders#send_reminders', as: :redmine_ir_send
  end

  # Botón desde el ticket individual
  post 'issues/:issue_id/reminder/send', to: 'issue_reminders#send_single', as: :redmine_ir_send_single
end
