require "rails_helper"

RSpec.describe SourceObservation, type: :model do
  subject { create(:source_observation) }

  describe "associations" do
    it { should have_and_belong_to_many(:trends) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
