module API::V1
  class APIController < ActionController::Base
    # include JSONAPI::Errors
    include JSONAPI::Pagination
    include JSONAPI::Filtering
    include JSONAPI::Fetching

    before_action :authenticate
    skip_before_action :verify_authenticity_token

    private

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        # This is vulnerable to timing attacks but we don't really have to care
        # since 1) the API is read-only 2) all data is public to start with
        # 3) anyone can just register and get a token.
        User.find_by(token:)
      end
    end

    def current_user
      @current_user ||= authenticate
    end
  end
end
