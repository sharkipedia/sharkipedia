module ApplicationHelper
  def user_is_admin?
    current_user.try(:admin?)
  end

  def link_to_doi doi
    link_to doi, "https://www.doi.org/#{doi}", target: '_blank' if doi
  end
end
