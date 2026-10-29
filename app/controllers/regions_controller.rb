# Public GeoJSON for the marine region layers drawn on the trend map.
#
#   GET /regions/fao.geojson             every FAO major area
#   GET /regions/fao.geojson?codes=21,31 only those areas
class RegionsController < PreAuthController
  def show
    layer = params[:layer]
    codes = params[:codes]&.split(",")&.map(&:strip)&.compact_blank&.sort&.uniq
    collection = Regions::FeatureCollection.new(layer, codes:)
    version = collection.cache_version

    expires_in 1.day, public: true
    return unless stale?(etag: [layer, codes, version], public: true)

    body = Rails.cache.fetch(["regions", layer, codes, version]) { collection.call }
    render body:, content_type: "application/geo+json"
  end
end
