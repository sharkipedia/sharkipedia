require "open-uri"

module Regions
  # Loads region polygons into the geom columns of our existing region rows.
  #
  # Features are matched to our rows by code or name (never by external ids),
  # so the stored geometry is tied to the records trends already reference.
  # Rows without a matching feature get their geom cleared, which keeps the
  # loader idempotent: running it twice yields the same state.
  #
  #   Regions::Loader.call                      # all layers, default sources
  #   Regions::Loader.call(layers: %w[ppow], sources: {"ppow" => "/path/ppow.geojson"})
  class Loader < ApplicationService
    VLIZ_WFS = "https://geo.vliz.be/geoserver/wfs?service=WFS&version=1.1.0&request=GetFeature" \
      "&outputFormat=application/json&srsName=EPSG:4326&typeName="

    # UNEP-WCMC WCMC-036 (MEOW + PPOW, The Nature Conservancy 2012), public
    # ArcGIS feature service. maxAllowableOffset generalises server side
    # (0.01 deg ~ 1 km); the full-resolution PPOW download is ~80 MB.
    PPOW_URL = "https://data-gis.unep-wcmc.org/server/rest/services/Bio-geographicalRegions/" \
      "WCMC036_MEOW_PPOW_2007_2012/FeatureServer/0/query?where=type%3D%27PPOW%27" \
      "&outFields=type,provinc&outSR=4326&maxAllowableOffset=0.01&f=geojson"

    DEFAULT_SOURCES = {
      "longhurst" => "#{VLIZ_WFS}MarineRegions:longhurst",
      "fao" => "#{VLIZ_WFS}MarineRegions:fao",
      "meow" => "#{VLIZ_WFS}Ecoregions:provinces",
      "ppow" => PPOW_URL
    }.freeze

    LAYERS = DEFAULT_SOURCES.keys.freeze

    # Our longhurst_provinces.code values that differ from VLIZ's provcode
    # (Longhurst 2010 v4) for the same province.
    LONGHURST_CODE_ALIASES = {
      "BPRL" => "BPLR",
      "IND E" => "INDE",
      "IND W" => "INDW",
      "NAST E" => "NASE",
      "NAST W" => "NASW"
    }.freeze

    def initialize(layers: LAYERS, sources: {}, logger: Rails.logger)
      @layers = Array(layers).map(&:to_s)
      unknown = @layers - LAYERS
      raise ArgumentError, "Unknown layer(s): #{unknown.join(", ")}" if unknown.any?

      @sources = DEFAULT_SOURCES.merge(sources.transform_keys(&:to_s).compact)
      @logger = logger
    end

    def call
      @layers.index_with { |layer| load_layer(layer) }
    end

    private

    def load_layer(layer)
      source = @sources.fetch(layer)
      log "#{layer}: reading #{source}"
      features = JSON.parse(read(source)).fetch("features")

      rows = rows_for(layer)
      rows_by_key = rows.index_by { |row| row_key(layer, row) }
      grouped = features.group_by { |feature| feature_key(layer, feature["properties"]) }

      matched = grouped.slice(*rows_by_key.keys)
      unused_features = grouped.keys - rows_by_key.keys
      unmatched_rows = rows_by_key.except(*grouped.keys).values

      check_meow_numbers(matched, rows_by_key) if layer == "meow"

      rows.first.class.transaction do
        rows.first.class.where(id: unmatched_rows.map(&:id)).update_all("geom = NULL")
        matched.each { |key, feats| store(rows_by_key.fetch(key), feats) }
      end

      result = {
        matched: matched.size,
        unmatched_rows: unmatched_rows.map { |row| row_key(layer, row) },
        unused_features: unused_features
      }
      log "#{layer}: #{result.inspect}"
      result
    end

    def rows_for(layer)
      case layer
      when "longhurst" then LonghurstProvince.all.to_a
      when "fao" then FaoArea.where(f_level: "MAJOR").to_a
      when "meow" then MarineEcoregionsWorld.meow.to_a
      when "ppow" then MarineEcoregionsWorld.ppow.to_a
      end
    end

    def row_key(layer, row)
      case layer
      when "longhurst" then LONGHURST_CODE_ALIASES.fetch(row.code, row.code)
      when "fao" then row.f_code
      when "meow", "ppow" then normalize(row.province)
      end
    end

    def feature_key(layer, props)
      case layer
      when "longhurst" then props["provcode"].to_s.strip
      when "fao" then props["zone"].to_s.strip
      when "meow" then normalize(props["province"])
      when "ppow" then normalize(props["provinc"] || props["province"] || props["PROVINC"] || props["PROVINCE"])
      end
    end

    def normalize(name)
      I18n.transliterate(name.to_s).downcase.squish
    end

    # Our MEOW trend_reg_id came from the old dataset's FIRST_Numb. Matching is
    # by name; this only warns if the numbering ever diverges from prov_code.
    def check_meow_numbers(matched, rows_by_key)
      matched.each do |key, feats|
        row = rows_by_key.fetch(key)
        code = feats.first.dig("properties", "prov_code")
        next if code.nil? || code.to_i == row.trend_reg_id

        log "meow: #{row.province} has trend_reg_id #{row.trend_reg_id} but prov_code #{code}"
      end
    end

    def store(row, features)
      geometries = features.map { |feature| feature.fetch("geometry").to_json }
      sql = <<~SQL
        UPDATE #{row.class.quoted_table_name}
        SET updated_at = now(), geom = (
          SELECT ST_Multi(ST_CollectionExtract(ST_Union(
            ST_MakeValid(ST_SetSRID(ST_GeomFromGeoJSON(g), 4326))
          ), 3))
          FROM unnest(ARRAY[?]::text[]) AS g
        )
        WHERE id = ?
      SQL
      row.class.connection.execute(row.class.sanitize_sql_array([sql, geometries, row.id]))
    end

    def read(source)
      if source.match?(%r{\Ahttps?://})
        URI.parse(source).open(read_timeout: 600, open_timeout: 30, &:read)
      else
        File.read(source)
      end
    end

    def log(message)
      @logger&.info(message)
    end
  end
end
