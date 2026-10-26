# Region polygons (geom) are large and only ever read or written in SQL
# (Regions::Loader, Regions::FeatureCollection, LonghurstProvince.containing). Ignoring
# the column keeps ordinary queries (trend pages, exports, admin) from
# loading and parsing megabytes of geometry.
module RegionGeometry
  extend ActiveSupport::Concern

  included do
    self.ignored_columns += ["geom"]

    scope :with_geom, -> { where("#{quoted_table_name}.geom IS NOT NULL") }
  end
end
