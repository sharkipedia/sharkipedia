class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def ensure_contributor!
    redirect_to root_path unless current_user.try(:contributor?)
  end

  def ensure_admin!
    redirect_to root_path unless current_user.try(:admin?)
  end

  private

  def record_not_found exception
    if Rails.env.development?
      raise exception
    else
      Bugsnag.notify(exception)
      redirect_to root_path
    end
  end

  def user_not_authorized exception
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = "#{policy_name}.#{exception.query}"
    redirect_to root_path
  end
end
