require "rails_helper"

RSpec.describe Import, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:approved_by).class_name("User").optional }

    it { should have_many(:trends) }
    it { should have_many(:observations) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
  end
end
