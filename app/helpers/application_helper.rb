module ApplicationHelper
  def user_is_admin?
    current_user.try(:admin?)
  end
end
