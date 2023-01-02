class ImportMailer < ApplicationMailer
  # notification to the uploaded that the state of their upload had changed
  def update_import_status_email
    @import = params[:import]
    mail subject: "[sharkipedia] - Import status changed to #{@import.state}",
      to: @import.user.email
  end

  def weekly_import_summary_email
    @imports_pending_review = Import.pending_review
    @grouped_imports_pending_review = @imports_pending_review.group_by(&:import_type)
    mail subject: "[sharkipedia] - CW #{Date.current.cweek} import digest",
      to: params[:emails]
  end
end
