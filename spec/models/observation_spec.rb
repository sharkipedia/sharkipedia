require "rails_helper"

RSpec.describe Observation, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:import) }
    it { should have_and_belong_to_many(:references) }
    it { should have_many(:measurements) }
    it { should have_many(:longhurst_provinces) }
    it { should have_many(:locations) }
    it { should have_many(:species) }
  end

  describe "validations" do
    it { should validate_presence_of(:references) }
  end

  describe "#title" do
    subject { observation.title }
    let!(:observation) { create(:observation) }
    let!(:measurement) { create(:measurement, observation:) }
    let!(:species_names) { observation.species.map(&:name).join }
    let!(:reference_names) { observation.references.map(&:name).join }

    it { should eq("#{species_names} - #{reference_names}") }

    context "when no species" do
      let!(:observation) { create(:observation) }
      let!(:measurement) { nil }

      it { should eq(reference_names) }
    end
  end

  describe "default scope" do
    it "adds a clause to order by created_at" do
      expect(described_class.all.to_sql).to eq(described_class.order(:created_at).to_sql)
    end
  end

  describe ".published" do
    subject { described_class.published }
    let!(:observation) { create(:observation) }
    let!(:hidden_observation) { create(:observation, :unpublished) }

    it { is_expected.to include(observation) }
    it { is_expected.not_to include(hidden_observation) }
  end

  describe "#species through measurements" do
    let(:species) { create(:species) }
    let(:observation) { create(:observation) }
    before do
      create(:measurement, species:, observation:)
      create(:measurement, species:, observation:)
    end

    it "is expected to be distinct" do
      expect(observation.species).to match_array([species])
    end
  end
end
