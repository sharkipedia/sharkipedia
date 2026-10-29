require "rails_helper"

RSpec.describe Regions::Loader do
  let(:dir) { Pathname(Dir.mktmpdir) }

  after { FileUtils.remove_entry(dir) }

  def square(x, y, size = 1)
    {"type" => "Polygon", "coordinates" => [[[x, y], [x + size, y], [x + size, y + size], [x, y + size], [x, y]]]}
  end

  def source(name, features)
    path = dir.join("#{name}.geojson")
    path.write({
      "type" => "FeatureCollection",
      "features" => features.map { |props, geometry| {"type" => "Feature", "properties" => props, "geometry" => geometry} }
    }.to_json)
    path.to_s
  end

  def geometry_of(record)
    record.class.where(id: record.id).pick(Arel.sql("ST_AsText(geom)"))
  end

  def area_of(record)
    record.class.where(id: record.id).pick(Arel.sql("ST_Area(geom)"))
  end

  it "stores Longhurst polygons by code, mapping our legacy codes" do
    nwcs = create(:longhurst_province, code: "NWCS")
    nasw = create(:longhurst_province, code: "NAST W")
    orphan = create(:longhurst_province, :with_geom, code: "NPSE")
    path = source("longhurst", [[{"provcode" => "NWCS"}, square(0, 0)], [{"provcode" => "NASW"}, square(5, 5)], [{"provcode" => "XXXX"}, square(9, 9)]])

    result = described_class.call(layers: %w[longhurst], sources: {longhurst: path}, logger: nil)

    expect(geometry_of(nwcs)).to start_with("MULTIPOLYGON")
    expect(geometry_of(nasw)).to start_with("MULTIPOLYGON")
    expect(geometry_of(orphan)).to be_nil
    expect(result["longhurst"]).to eq(matched: 2, unmatched_rows: ["NPSE"], unused_features: ["XXXX"])
  end

  it "dissolves several FAO features for the same major area" do
    area = create(:fao_area, f_code: "88")
    path = source("fao", [[{"zone" => 88}, square(0, 0)], [{"zone" => 88}, square(1, 0)]])

    described_class.call(layers: %w[fao], sources: {fao: path}, logger: nil)

    expect(area_of(area)).to be_within(0.001).of(2)
  end

  it "matches MEOW and PPOW provinces by name, ignoring accents and case" do
    meow = create(:marine_ecoregions_world, region_type: "MEOW", province: "Juan Fernández and Desventuradas", trend_reg_id: 46)
    ppow = create(:marine_ecoregions_world, region_type: "PPOW", province: "Gulf Stream", trend_reg_id: 28)
    meow_path = source("meow", [[{"province" => "Juan Fernandez and Desventuradas", "prov_code" => 46.0}, square(0, 0)]])
    ppow_path = source("ppow", [[{"provinc" => "gulf stream"}, square(0, 0)]])

    described_class.call(layers: %w[meow ppow], sources: {meow: meow_path, ppow: ppow_path}, logger: nil)

    expect(geometry_of(meow)).to be_present
    expect(geometry_of(ppow)).to be_present
  end

  it "is idempotent" do
    nwcs = create(:longhurst_province, code: "NWCS")
    path = source("longhurst", [[{"provcode" => "NWCS"}, square(0, 0)]])

    2.times { described_class.call(layers: %w[longhurst], sources: {longhurst: path}, logger: nil) }

    expect(area_of(nwcs)).to be_within(0.001).of(1)
  end

  it "rejects unknown layers" do
    expect { described_class.new(layers: %w[eez]) }.to raise_error(ArgumentError)
  end
end
