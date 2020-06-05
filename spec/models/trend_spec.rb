require "rails_helper"

RSpec.describe Trend, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:import) }
    it { should belong_to(:reference) }
    it { should belong_to(:species).optional }
    it { should belong_to(:species_group).optional }
    it { should belong_to(:location) }
    it { should belong_to(:ocean) }
    it { should belong_to(:data_type) }
    it { should belong_to(:sampling_method) }
    it { should belong_to(:standard) }
    it { should belong_to(:unit_time).optional }
    it { should belong_to(:unit_spatial).optional }
    it { should belong_to(:unit_gear).optional }
    it { should belong_to(:unit_transformation).optional }
    it { should belong_to(:analysis_model).optional }

    it { should have_many(:trend_observations) }
    it { should have_and_belong_to_many(:source_observations) }
    it { should have_and_belong_to_many(:fao_areas) }
  end

  describe "validations" do
    it { should validate_presence_of(:start_year) }
    it { should validate_presence_of(:end_year) }

    context "with Species" do
      subject { build(:trend) }
      it { should be_valid }
    end

    context "with SpeciesGroup" do
      subject { build(:trend_with_species_group) }
      it { should be_valid }
    end

    context "without Species or SpeciesGroup" do
      subject { build(:trend, species: nil, species_group: nil) }
      it { should_not be_valid }
    end
  end
end
