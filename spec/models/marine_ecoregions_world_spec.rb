require "rails_helper"

RSpec.describe MarineEcoregionsWorld, type: :model do
  subject { create(:marine_ecoregions_world) }

  describe "associations" do
    it { should have_and_belong_to_many(:trends) }
  end

  describe "validations" do
    it { should validate_presence_of(:unep_fid) }
    it { should validate_presence_of(:region_type) }
    it { should validate_presence_of(:province) }

    it { should validate_uniqueness_of(:unep_fid) }
  end
end
