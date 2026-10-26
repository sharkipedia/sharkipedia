require "rails_helper"

RSpec.describe "Regions", type: :request do
  def json = JSON.parse(response.body)

  before do
    create(:fao_area, :with_geom, f_code: "21", name: "Atlantic, Northwest")
    create(:fao_area, :with_geom, f_code: "31", name: "Atlantic, Western Central")
    create(:fao_area, f_code: "27")
  end

  it "returns every region of a layer as a GeoJSON FeatureCollection without login" do
    get "/regions/fao.geojson"

    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/geo+json")
    expect(response.headers["Cache-Control"]).to include("public")
    expect(json["type"]).to eq("FeatureCollection")
    expect(json["features"].map { |f| f["properties"]["code"] }).to eq(%w[21 31])
    expect(json["features"].first["geometry"]["type"]).to eq("MultiPolygon")
    expect(json["features"].first["properties"]["name"]).to eq("Atlantic, Northwest")
  end

  it "filters by codes" do
    get "/regions/fao.geojson", params: {codes: "31"}

    expect(json["features"].map { |f| f["properties"]["code"] }).to eq(%w[31])
  end

  it "returns an empty collection when nothing matches" do
    get "/regions/fao.geojson", params: {codes: "99"}

    expect(json).to eq("type" => "FeatureCollection", "features" => [])
  end

  it "uses trend_reg_id as the code for MEOW and PPOW" do
    create(:marine_ecoregions_world, :with_geom, region_type: "MEOW", trend_reg_id: 6, province: "Warm Temperate Northwest Atlantic")
    create(:marine_ecoregions_world, :with_geom, region_type: "PPOW", trend_reg_id: 28, province: "Gulf Stream")

    get "/regions/meow.geojson"
    expect(json["features"].map { |f| f["properties"]["code"] }).to eq(%w[6])

    get "/regions/ppow.geojson", params: {codes: "28"}
    expect(json["features"].map { |f| f["properties"]["name"] }).to eq(["Gulf Stream"])
  end

  it "answers conditional requests with 304" do
    get "/regions/fao.geojson"
    get "/regions/fao.geojson", headers: {"If-None-Match" => response.headers["ETag"]}

    expect(response).to have_http_status(:not_modified)
  end

  it "gzips the response when the client accepts it" do
    get "/regions/fao.geojson", headers: {"Accept-Encoding" => "gzip"}

    expect(response.headers["Content-Encoding"]).to eq("gzip")
  end

  it "rejects unknown layers" do
    get "/regions/eez.geojson"

    expect(response).to have_http_status(:not_found)
  end
end
