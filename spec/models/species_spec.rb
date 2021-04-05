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
  end
end
