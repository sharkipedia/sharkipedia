require "rails_helper"

RSpec.describe DOIValidator do
  let(:thing_class) do
    Struct.new(:doi) do
      include ActiveModel::Validations
      validates_with DOIValidator
    end
  end

  [
    [true, "10.1111/jfb.12087"],
    [true, nil],
    [true, ""],
    [false, "0.1111/jfb.12087"]
  ].each do |valid, doi|
    it "DOI #{doi.inspect} valid? to be #{valid}" do
      thing = thing_class.new doi
      expect(thing.valid?).to be(valid)
    end
  end
end
