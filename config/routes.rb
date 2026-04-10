RedmineApp::Application.routes.draw do
  # Panel de administración
  scope '/admin' do
    get  'issue_reminders',      to: 'issue_reminders#index',          as: :issue_reminders
    post 'issue_reminders/send', to: 'issue_reminders#send_reminders', as: :send_issue_reminders
  end

  # Botón desde el ticket individual
  post 'issues/:issue_id/reminder/send', to: 'issue_reminders#send_single', as: :send_single_issue_reminder
end
