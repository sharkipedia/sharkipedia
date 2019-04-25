require 'rails_helper'

RSpec.describe Resource, type: :model do
  [
    [true, '10.1111/jfb.12087'],
    [true, nil],
    [true, ''],
    [false, '0.1111/jfb.12087'],
  ].each do |valid, doi|
    it "DOI #{doi.inspect} valid? to be #{valid}" do
      resource = Resource.new name: 'some resource', doi: doi
      expect(resource.valid?).to be(valid)
    end
  end
end
