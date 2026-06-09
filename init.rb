require File.expand_path('../issue_show_hook', __FILE__)

Redmine::Plugin.register :redmine_issue_reminder do
  name 'Redmine Issue Reminder'
  author 'Custom'
  description 'Sends email reminders to users with assigned open issues'
  version '1.1.0'

  settings default: {
    'auto_enabled'     => '0',
    'auto_days'        => '1',
    'auto_project_ids' => [],
    'auto_status_ids'  => []
  }, partial: 'settings/redmine_issue_reminder'

  menu :admin_menu,
       :issue_reminder,
       { controller: 'issue_reminders', action: 'index' },
       caption: Proc.new { I18n.t(:ir_menu_caption) },
       html: { class: 'icon icon-email' }
end
