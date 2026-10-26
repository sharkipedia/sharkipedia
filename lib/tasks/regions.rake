namespace :regions do
  desc <<~DESC
    Load Longhurst, FAO, MEOW and PPOW polygons into the region tables.
    Idempotent. Optional: LAYERS=longhurst,fao,meow,ppow and per-layer source
    overrides (URL or local GeoJSON path), e.g. PPOW_SOURCE=/tmp/ppow.geojson
  DESC
  task load: :environment do
    layers = ENV.fetch("LAYERS", Regions::Loader::LAYERS.join(",")).split(",").map(&:strip)
    sources = Regions::Loader::LAYERS.to_h { |layer| [layer, ENV["#{layer.upcase}_SOURCE"].presence] }
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = ->(_, _, _, msg) { "#{msg}\n" }

    Regions::Loader.call(layers:, sources:, logger:)
    Rails.cache.delete_matched("regions/*") if Rails.cache.respond_to?(:delete_matched)
  end
end
