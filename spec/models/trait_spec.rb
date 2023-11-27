require "rails_helper"

RSpec.describe Trait, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "associations" do
    it { should have_many(:measurements) }
    it { should belong_to(:trait_class) }
  end

  describe ".search_by_name" do
    let!(:trait1) { create(:trait, name: "Height") }
    let!(:trait2) { create(:trait, name: "Width") }

    it "returns the correct trait according to search term" do
      expect(Trait.search_by_name("Wi")).to include(trait2)
      expect(Trait.search_by_name("Wi")).not_to include(trait1)
    end
  end
end
