module Admin
  class ApplicationController < Administrate::ApplicationController
    include Administrate::Punditize

    before_action :authenticate_user!
    before_action :authenticate_admin

    def authenticate_admin
      unless current_user.admin? || current_user.editor?
        redirect_to root_path
      end
    end
  end
end
