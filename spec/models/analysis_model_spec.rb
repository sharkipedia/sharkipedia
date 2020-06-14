require "rails_helper"

RSpec.describe AnalysisModel, type: :model do
  subject { create(:analysis_model) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "associations" do
    it { should have_many(:trends) }
  end
end
