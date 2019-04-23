class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  def ensure_admin!
    redirect_to root_path unless current_user.try(:admin?)
  end
end
