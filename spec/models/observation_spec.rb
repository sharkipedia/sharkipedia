require "rails_helper"

RSpec.describe Observation, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:import) }
    it { should have_and_belong_to_many(:references) }
    it { should have_many(:measurements) }
    it { should have_many(:longhurst_provinces) }
    it { should have_many(:locations) }
  end

  describe "validations" do
    it { should validate_presence_of(:references) }
    it { should validate_presence_of(:species) }
  end

  describe "#title" do
    subject { observation.title }
    let(:observation) { create(:observation) }

    it { should eq("#{observation.species.name} - #{observation.references.map(&:name)}") }
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
end
