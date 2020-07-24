require "rails_helper"

RSpec.describe Standard, type: :model do
  describe "associations" do
    it { should have_many(:measurements) }
    it { should have_many(:trends) }
  end
end
