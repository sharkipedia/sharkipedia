module Export
  class Traits < ApplicationService
    def initialize(observations=nil)
      @observations = observations || Observation.published
    end

    def call
      CSV.generate do |csv|
        csv << %w{
reference_name reference_doi species_superorder species_name marine_province location_name lat long date sex trait_class trait_name standard_name method_name model_name value value_type precision precision_type precision_upper sample_size dubious validated validation_type notes contributor_id depth 
        }

        @observations.each do |observation|
          observation.measurements.each do |measurement|
            csv << [
              observation.references.first.name,
              observation.references.first.doi,
              observation.species.species_superorder.name,
              observation.species.name,
              observation.longhurst_province.try(:name),
              measurement.location.name,
              measurement.location.lat,
              measurement.location.lon,
              measurement.date,
              measurement.sex_type.name,
              measurement.trait_class.name,
              measurement.trait.name,
              measurement.standard.try(:name),
              measurement.measurement_method.try(:name),
              measurement.measurement_model.try(:name),
              measurement.value,
              measurement.value_type.try(:name),
              measurement.precision,
              measurement.precision_type.try(:name),
              measurement.precision_upper,
              measurement.sample_size,
              measurement.dubious,
              measurement.validated,
              measurement.validation_type.try(:name),
              measurement.notes,
              observation.contributor_id,
              observation.depth,
            ]
          end
        end
      end
    end
  end
end
