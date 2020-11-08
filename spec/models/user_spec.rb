require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:imports) }
    it { should have_many(:observations) }
    it { should have_many(:trends) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:token) }
  end
end
