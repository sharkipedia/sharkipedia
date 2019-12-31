class ImportMailer < ApplicationMailer
  # notification to editors that a new import was uploaded and needs to be
  # reviewed
  def new_import_email
    @import = params[:import]
    mail subject: "[SharkT] - New Import uploaded", to: User.admin_emails
  end

  # notification to the uploaded that the state of their upload had changed
  def update_import_status_email
    @import = params[:import]
    mail subject: "[SharkT] - Import status changed to #{@import.state}",
         to: @import.user.email
  end
end
