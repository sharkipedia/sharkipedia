require "rails_helper"

RSpec.describe TraitClass, type: :model do
  describe 'validations' do
    subject { build(:trait_class)}

    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_uniqueness_of(:name)}
  end

  describe 'associations' do
    it { should have_many(:traits) }
    it { should have_many(:standards) }
    it { should have_many(:measurement_methods) }
    it { should have_many(:measurement_models) }
  end
end
