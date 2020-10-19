require "rails_helper"

RSpec.describe Location, type: :model do
  describe "associations" do
    it { should have_many(:measurements) }
    it { should have_many(:trends) }
    it { should have_many(:observations) }
  end

  describe "coordinates" do
    context "when valid latitude & longitude" do
      subject(:location) { create(:location, lat: lat, lon: lon) }

      let(:lat) { "33" }
      let(:lon) { "147" }

      it { should be_valid }
      it { expect(location.latitude).to eq(lat.to_f) }
      it { expect(location.longitude).to eq(lon.to_f) }
    end

    context "when no coordinates" do
      subject(:location) { create(:location, lat: nil, lon: nil, lonlat: nil) }

      it { should be_valid }
      it { expect(location.latitude).to be_nil }
      it { expect(location.longitude).to be_nil }
    end

    context "when invalid longitude" do
      ["hi mom", -200, 200].each do |value|
        subject { build(:location, lon: value) }
        it { should_not be_valid }
      end
    end

    context "when invalid latitude" do
      ["hi mom", -100, 100].each do |value|
        subject { build(:location, lat: value) }
        it { should_not be_valid }
      end
    end
  end
end
