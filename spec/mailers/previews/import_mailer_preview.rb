# Preview all emails at http://localhost:3000/rails/mailers/import_mailer
class ImportMailerPreview < ActionMailer::Preview
  def new_import_email
    ImportMailer.with(import: Import.first).new_import_email
  end

  def update_import_status_email
    ImportMailer.with(import: Import.first).update_import_status_email
  end
end
