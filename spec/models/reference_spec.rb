require 'rails_helper'

RSpec.describe Reference, type: :model do
  [
    [true, '10.1111/jfb.12087'],
    [true, nil],
    [true, ''],
    [false, '0.1111/jfb.12087'],
  ].each do |valid, doi|
    it "DOI #{doi.inspect} valid? to be #{valid}" do
      reference = Reference.new name: 'some reference', doi: doi
      expect(reference.valid?).to be(valid)
    end
  end
end
