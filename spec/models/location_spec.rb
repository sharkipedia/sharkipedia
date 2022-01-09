require "rails_helper"

RSpec.describe Location, type: :model do
  describe "associations" do
    it { should have_many(:measurements) }
    it { should have_many(:trends) }
    it { should have_many(:observations) }
  end

  describe "coordinates" do
    context "when valid latitude & longitude" do
      subject(:location) { create(:location, lat:, lon:) }

      let(:lat) { "33" }
      let(:lon) { "147" }

      it { should be_valid }
      it { expect(location.latitude).to eq(lat.to_f) }
      it { expect(location.longitude).to eq(lon.to_f) }
    end

    shared_examples "valid with blank latitude & longitude" do
      it { should be_valid }
      it { expect(location.latitude).to be_nil }
      it { expect(location.longitude).to be_nil }
    end

    context "when nil coordinates" do
      subject(:location) { create(:location, lat: nil, lon: nil, lonlat: nil) }

      it_behaves_like "valid with blank latitude & longitude"
    end

    context "when '' coordinates" do
      subject(:location) { create(:location, lat: "", lon: "", lonlat: "") }

      it_behaves_like "valid with blank latitude & longitude"
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
