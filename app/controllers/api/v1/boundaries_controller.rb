module API::V1
  class BoundariesController < APIController
    Boundary = Struct.new(:id, :name) {}
    BOUNDARIES = [
      Boundary.new(1, "Ocean"),
      Boundary.new(2, "Eez")
    ]

    def index
      render jsonapi: BOUNDARIES
    end

    def show
      case params[:name]
      when /Oceans?/i
        render jsonapi: Ocean.all
      when /eezs?/i
        jsonapi_paginate(Eez.select_without_geom) do |paginated|
          render jsonapi: paginated
        end
      end
    end

    private

    def jsonapi_meta(resources)
      pagination = jsonapi_pagination_meta(resources)

      {
        total: (resources.count if resources.respond_to?(:count)),
        pagination: (pagination if pagination.present?)
      }.compact
    end

    def jsonapi_serializer_class(resource, is_collection)
      JSONAPI::Rails.serializer_class(resource, is_collection)
    rescue NameError
      BoundariesSerializer
    end
  end
end
