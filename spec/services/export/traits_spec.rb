require "rails_helper"

RSpec.describe Export::Traits do
  let(:measurement) { create(:measurement) }
  let(:observation) { measurement.observation }

  let(:exporter) { Export::Traits.new([observation]) }
  let(:csv_header) { exporter.call.split("\n").first }
  let(:csv_measurement) { exporter.call.split("\n").last }

  let(:expected_header) do
    %w[
      reference_name reference_doi species_superorder species_name marine_province location_name lat long date sex trait_class trait_name standard_name method_name model_name value value_type precision precision_type precision_upper sample_size dubious validated validation_type notes contributor_id depth
    ].join(",")
  end

  let(:expected_measurement) do
    [
      observation.references.first.name,
      observation.references.first.doi,
      measurement.species.species_superorder.name,
      measurement.species.name,
      measurement.longhurst_province.name,
      measurement.location.name,
      measurement.location.latitude,
      measurement.location.longitude,
      measurement.date,
      measurement.sex_type.name,
      measurement.trait_class.name,
      measurement.trait.name,
      measurement.standard.name,
      measurement.measurement_method.name,
      measurement.measurement_model.name,
      measurement.value,
      measurement.value_type.name,
      measurement.precision,
      measurement.precision_type.name,
      measurement.precision_upper,
      measurement.sample_size,
      measurement.dubious,
      measurement.validated,
      measurement.validation_type.name,
      measurement.notes,
      observation.contributor_id,
      observation.depth
    ].join(",")
  end

  it "exports the correct headers" do
    expect(csv_header).to eq(expected_header)
  end

  it "exports the correct data" do
    expect(csv_measurement).to eq(expected_measurement)
  end
end
