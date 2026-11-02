module Admin
  class ReferencesController < Admin::ApplicationController
    def find_resource(slug)
      Reference.friendly.find(slug)
    end
  end
end
