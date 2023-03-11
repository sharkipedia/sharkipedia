class DataExportController < PreAuthController
  def index
    if params[:commit]
      data, exporter = if params[:export_type] == "Traits"
        [
          policy_scope(Observation).includes(
            :references,
            {
              species: :species_superorder
            },
            {
              measurements: [
                :location, :sex_type, :standard,
                :measurement_model, :measurement_method,
                :value_type, :precision_type,
                :validation_type, :trait, :trait_class,
                :longhurst_province
              ]
            }
          ),
          Export::Traits
        ]
      else
        [Trend.all, Export::Trends]
      end

      @species = []
      if params[:species]
        species_ids = params[:species].reject(&:blank?)
        data = if species_ids.any?
          @species = Species.where id: species_ids
          data.where({measurements: {species_id: @species}})
        end
      end

      @data = exporter.new(data).call
    end
  end
end
