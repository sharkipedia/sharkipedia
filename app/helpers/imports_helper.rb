module ImportsHelper
  def link_to_admin_dashboard import
    if current_user.admin?
      link_to import.uploaded_by, admin_user_path(import.user)
    else
      import.uploaded_by
    end
  end
end
