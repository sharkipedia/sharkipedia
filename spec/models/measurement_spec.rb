require "rails_helper"

RSpec.describe Measurement, type: :model do
  describe "associations" do
    it { should belong_to(:observation) }
    it { should belong_to(:longhurst_province).optional }
    it { should belong_to(:sex_type) }
    it { should belong_to(:trait) }
    it { should have_one(:trait_class) }
    it { should belong_to(:standard).optional }
    it { should belong_to(:measurement_method).optional }
    it { should belong_to(:measurement_model).optional }
    it { should belong_to(:value_type).optional }
    it { should belong_to(:validation_type).optional }
    it { should belong_to(:precision_type).optional }
    it { should belong_to(:location) }
  end
end
