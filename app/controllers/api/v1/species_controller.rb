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

    def query
      results = if params[:geometry]
        find_species_by_geometry
      elsif params[:oceans]
        find_species_by_oceans
      elsif params[:eez_id]
        find_species_by_eez
      else
        []
      end

      jsonapi_paginate(results) do |paginated|
        render jsonapi: paginated
      end
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

    def find_species_by_eez
      query = <<~SQL
        SELECT * FROM locations
        WHERE ST_Intersects(lonlat, (
          SELECT geom FROM #{Eez.table_name} WHERE fid = ?
        ))
      SQL

      locations = Location.find_by_sql([query, params[:eez_id]])

      Species.joins(:trends).where(trends: {location: locations}) +
        Species.joins(observations: :measurements).where(measurements: {location_id: locations})
    rescue ActiveRecord::StatementInvalid
      []
    end

    def find_species_by_oceans
      oceans = Ocean.where name: params[:oceans]
      oceans&.map(&:species)&.flatten
    end

    def find_species_by_geometry
      locations = Location.where("ST_Intersects(lonlat, '" + geometry.first.geometry.as_text + "')")

      Species.joins(:trends).where(trends: {location: locations}) +
        Species.joins(observations: :measurements).where(measurements: {location_id: locations})
    end

    def geometry
      RGeo::GeoJSON.decode params[:geometry]
    rescue JSON::ParserError
      {}
    end
  end
end
