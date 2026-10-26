module Regions
  # Builds a GeoJSON FeatureCollection for one region layer straight from
  # PostGIS. Each feature carries {id, code, name}, where code is what the
  # trend page uses to highlight it (Longhurst code, FAO f_code, MEOW/PPOW
  # trend_reg_id).
  #
  #   Regions::FeatureCollection.call("fao")                  # every FAO major area
  #   Regions::FeatureCollection.call("fao", codes: %w[21 31]) # only those two
  class FeatureCollection < ApplicationService
    # Degrees. Chosen so the layers stay a few hundred KB each while
    # still looking right at zoom 2-8.
    SIMPLIFY_TOLERANCE = 0.05
    # ~1 km precision.
    COORDINATE_DIGITS = 2

    LAYERS = {
      "longhurst" => {scope: -> { LonghurstProvince.all }, code: "code", name: "name"},
      "fao" => {scope: -> { FaoArea.where(f_level: "MAJOR") }, code: "f_code", name: "name"},
      "meow" => {scope: -> { MarineEcoregionsWorld.meow }, code: "trend_reg_id::text", name: "province"},
      "ppow" => {scope: -> { MarineEcoregionsWorld.ppow }, code: "trend_reg_id::text", name: "province"}
    }.freeze

    def self.layers = LAYERS.keys

    def initialize(layer, codes: nil)
      @config = LAYERS.fetch(layer.to_s)
      @codes = codes&.map(&:to_s)
    end

    # Changes whenever the loader rewrites the layer; use it in cache keys.
    def cache_version
      scope.with_geom.pick(Arel.sql("count(*), max(#{scope.quoted_table_name}.updated_at)")).join("-")
    end

    def call
      features = scope.with_geom.select(Arel.sql(<<~SQL))
        json_build_object(
          'type', 'Feature',
          'id', id,
          'properties', json_build_object('id', id, 'code', #{@config[:code]}, 'name', #{@config[:name]}),
          'geometry', ST_AsGeoJSON(
            ST_Multi(ST_SimplifyPreserveTopology(geom, #{SIMPLIFY_TOLERANCE})), #{COORDINATE_DIGITS}
          )::json
        ) AS feature
      SQL
      features = features.where("#{@config[:code]} IN (?)", @codes) unless @codes.nil?

      sql = <<~SQL
        SELECT json_build_object(
          'type', 'FeatureCollection',
          'features', COALESCE(json_agg(f.feature), '[]'::json)
        )::text
        FROM (#{features.reorder(:id).to_sql}) f
      SQL
      scope.connection.select_value(sql)
    end

    private

    def scope
      @config[:scope].call
    end
  end
end
