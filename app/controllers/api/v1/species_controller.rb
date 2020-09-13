module API::V1
  class SpeciesController < APIController
    def index
      allowed = [:name, :edge_scientific_name]

      jsonapi_filter(Species.all, allowed) do |filtered|
        jsonapi_paginate(filtered.result) do |paginated|
          render jsonapi: paginated
        end
      end
    end

    def show
      species = Species.friendly.find params[:id]
      render jsonapi: species
    end

    private

    def jsonapi_include
      super & ["observations", "observations.measurements", "trends", "trends.trend_observations"]
    end

    def jsonapi_meta(resources)
      pagination = jsonapi_pagination_meta(resources)

      {
        total: (resources.count if resources.respond_to?(:count)),
        pagination: (pagination if pagination.present?)
      }.compact
    end
  end
end
