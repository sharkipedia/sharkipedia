require "rails_helper"

RSpec.describe SpeciesGroup, type: :model do
  subject(:species_group) { create(:species_group) }

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should have_and_belong_to_many(:species) }
    it { should have_many(:trends) }
  end
end
