require "rails_helper"

RSpec.describe Ocean, type: :model do
  describe "associations" do
    it { should have_and_belong_to_many(:trends) }
  end
end
