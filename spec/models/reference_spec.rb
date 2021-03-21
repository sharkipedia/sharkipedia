require "rails_helper"

RSpec.describe Reference, type: :model do
  subject { create(:reference) }

  describe "associations" do
    it { should have_and_belong_to_many(:observations) }
    it { should have_many(:trends) }
    it { should have_one_attached(:reference_file) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  [
    [true, "10.1111/jfb.12087"],
    [true, nil],
    [true, ""],
    [false, "0.1111/jfb.12087"]
  ].each do |valid, doi|
    it "DOI #{doi.inspect} valid? to be #{valid}" do
      reference = Reference.new name: "some reference", doi: doi
      expect(reference.valid?).to be(valid)
    end
  end
end
