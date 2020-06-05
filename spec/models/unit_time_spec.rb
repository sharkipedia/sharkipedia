require "rails_helper"

RSpec.describe UnitTime, type: :model do
  subject { create(:unit_time) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "associations" do
    it { should have_many(:trends) }
  end
end
