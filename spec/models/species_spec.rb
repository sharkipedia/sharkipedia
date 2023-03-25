require "rails_helper"

RSpec.describe Species, type: :model do
  subject(:species) { create(:species) }

  describe "associations" do
    it { should have_and_belong_to_many(:species_groups) }
    it { should have_many(:measurements) }
    it { should have_many(:observations) }
    it { should have_many(:trends) }

    it { should belong_to(:species_superorder) }
    it { should belong_to(:species_data_type) }
    it { should belong_to(:species_subclass) }
    it { should belong_to(:species_order) }
    it { should belong_to(:species_family) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }

    describe "cites_status" do
      it { expect(build(:protected_species_cites)).to be_valid }

      it "should validate cites_status is not :none if cites_status_year is set" do
        expect(build(:protected_species_cites, cites_status: :none, cites_status_year: 2000)).not_to be_valid
      end

      it "should validate cites_status is :none if cites_status_year is an empty string" do
        expect(build(:protected_species_cites, cites_status: :none, cites_status_year: "")).to be_valid
      end

      it "should validate cites_status_year is not empty if cites_status" do
        expect(build(:protected_species_cites, cites_status_year: nil)).not_to be_valid
      end

      it "should have a properly formatted year" do
        expect(build(:protected_species_cites, cites_status_year: "shark")).not_to be_valid
      end
    end

    describe "cms_status" do
      it { expect(build(:protected_species_cms)).to be_valid }

      it "should validate cms_status is not :none if cms_status_year is set" do
        expect(build(:protected_species_cms, cms_status: :none)).not_to be_valid
      end

      it "should validate cites_status is :none if cms_status_year is an empty string" do
        expect(build(:protected_species_cms, cms_status: :none, cms_status_year: "")).to be_valid
      end

      it "should validate cms_status_year is not empty if cms_status" do
        expect(build(:protected_species_cms, cms_status_year: nil)).not_to be_valid
      end

      it "should have a properly formatted year" do
        expect(build(:protected_species_cms, cms_status_year: "shark")).not_to be_valid
      end
    end
  end

  describe "#protected_species?" do
    it { expect(build(:protected_species_cms)).to be_protected_species }

    it { expect(build(:protected_species_cites)).to be_protected_species }

    it { expect(build(:species)).not_to be_protected_species }
  end
end
