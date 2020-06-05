require "rails_helper"

RSpec.describe TrendObservation, type: :model do
  describe 'associations' do
    it { should belong_to(:trend) }
  end

  describe 'validations' do
    it { should validate_presence_of(:year) }
  end
end
