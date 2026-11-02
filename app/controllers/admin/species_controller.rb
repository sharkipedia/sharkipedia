module Admin
  class SpeciesController < Admin::ApplicationController
    def find_resource(slug)
      Species.friendly.find(slug)
    end
  end
end
