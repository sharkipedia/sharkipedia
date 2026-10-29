require "rails_helper"

RSpec.describe LonghurstProvince, type: :model do
  describe ".containing" do
    let!(:west) { create(:longhurst_province, :with_geom, code: "WEST", geom_wkt: "MULTIPOLYGON(((-20 0, -10 0, -10 10, -20 10, -20 0)))") }
    let!(:east) { create(:longhurst_province, :with_geom, code: "EAST", geom_wkt: "MULTIPOLYGON(((-10 0, 0 0, 0 10, -10 10, -10 0)))") }

    before { create(:longhurst_province, code: "NOGEOM") }

    it "returns the province containing the point" do
      expect(described_class.containing(longitude: -15, latitude: 5)).to eq(west)
      expect(described_class.containing(longitude: -5, latitude: 5)).to eq(east)
    end

    it "falls back to the nearest province just outside every polygon" do
      expect(described_class.containing(longitude: 0.5, latitude: 5)).to eq(east)
    end

    it "returns nil far from any province" do
      expect(described_class.containing(longitude: 50, latitude: 50)).to be_nil
    end

    it "returns nil without coordinates" do
      expect(described_class.containing(longitude: nil, latitude: 5)).to be_nil
    end
  end

  it "does not load the geometry with ordinary queries" do
    create(:longhurst_province, :with_geom)
    expect(described_class.first.attributes).not_to have_key("geom")
  end
end
