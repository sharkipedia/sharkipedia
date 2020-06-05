require "rails_helper"

RSpec.describe FaoArea, type: :model do
  subject { create(:fao_area) }

  describe "associations" do
    it { should belong_to(:ocean) }
    it { should have_and_belong_to_many(:trends) }
  end

  describe "validations" do
    it { should validate_presence_of(:f_code) }
    it { should validate_presence_of(:f_level) }
    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:f_code) }
  end
end
