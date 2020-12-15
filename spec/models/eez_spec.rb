require "rails_helper"

RSpec.describe Eez, type: :model do
  describe ".select_without_geom" do
    subject(:eez) { described_class.select_without_geom.first }

    it do
      expect { eez.geom }.to raise_error(ActiveModel::MissingAttributeError)
    end
  end

  describe "#name" do
    it { is_expected.to respond_to(:name) }
  end
end
