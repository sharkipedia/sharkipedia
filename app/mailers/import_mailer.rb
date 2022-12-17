class ImportMailer < ApplicationMailer
  # notification to the uploaded that the state of their upload had changed
  def update_import_status_email
    @import = params[:import]
    mail subject: "[sharkipedia] - Import status changed to #{@import.state}",
      to: @import.user.email
  end
end
