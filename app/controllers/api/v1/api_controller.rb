module API::V1
  class APIController < ActionController::Base
    # include JSONAPI::Errors
    include JSONAPI::Pagination
    include JSONAPI::Filtering
    include JSONAPI::Fetching
  end
end
