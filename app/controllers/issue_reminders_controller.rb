class IssueRemindersController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: [:index, :send_reminders]

  # GET /admin/issue_reminders
  def index
    @projects = Project.active.sorted
    @statuses = IssueStatus.where(is_closed: false).sorted
    @selected_project_ids = params[:project_ids] || []
    @selected_status_ids  = params[:status_ids]  || []
    @days_without_update  = params[:days_without_update].to_i
    @issues = fetch_issues
    @issues_by_user = @issues.group_by(&:assigned_to)
    @last_journal_by_issue = @issues.each_with_object({}) do |issue, h|
      h[issue.id] = issue.journals.select { |j| j.notes.present? }.max_by(&:created_on)
    end
  end

  # POST /admin/issue_reminders/send
  def send_reminders
    issue_ids = params[:issue_ids] || []
    if issue_ids.empty?
      flash[:error] = 'No seleccionaste ningún ticket.'
      redirect_to redmine_ir_panel_path and return
    end
    issues = Issue.where(id: issue_ids).includes(:assigned_to, :status, :project, :journals)
    issues_by_user = issues.group_by(&:assigned_to)
    sent_count = 0
    issues_by_user.each do |user, user_issues|
      next unless user.is_a?(User) && user.active? && user.mail.present?
      IssueReminderMailer.reminder_email(user, user_issues).deliver_now
      sent_count += 1
    end
    flash[:notice] = "Recordatorios enviados a #{sent_count} usuario(s) (#{issue_ids.size} tickets)."
    redirect_to redmine_ir_panel_path
  end

  # POST /issues/:issue_id/reminder/send  — botón desde el ticket
  def send_single
    @issue = Issue.find(params[:issue_id])

    # Permiso: admin O quien creó el ticket O quien lo tiene asignado
    unless User.current.admin? ||
           @issue.author_id == User.current.id ||
           @issue.assigned_to_id == User.current.id
      deny_access and return
    end

    user = @issue.assigned_to
    unless user.is_a?(User) && user.active? && user.mail.present?
      flash[:error] = 'El ticket no tiene un responsable válido con correo asignado.'
      redirect_to issue_path(@issue) and return
    end

    IssueReminderMailer.reminder_email(user, [@issue]).deliver_now
    flash[:notice] = "✉ Recordatorio enviado a #{user.name} (#{user.mail})."
    redirect_to issue_path(@issue)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  private

  def fetch_issues
    scope = Issue.open.includes(:assigned_to, :status, :project, :journals)
                 .where.not(assigned_to_id: nil)
    scope = scope.where(project_id: @selected_project_ids) if @selected_project_ids.any?
    scope = scope.where(status_id: @selected_status_ids)   if @selected_status_ids.any?
    scope = scope.where('issues.updated_on <= ?', @days_without_update.days.ago) if @days_without_update > 0
    scope.order('issues.updated_on ASC')
  end
end
