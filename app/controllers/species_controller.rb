class SpeciesController < PreAuthController
  include Pagy::Backend

  def index
    species = if params[:all]
      policy_scope(Species)
    else
      policy_scope(Species)
        .joins(observations: :import)
        .where('imports.aasm_state': 'imported')
        .order(:name).distinct
    end

    @pagy, @species = pagy(species)
  end

  def show
    @specie = Species.includes(
      observations: [
        measurements: [:standard, :value_type, :location, :trait, :sex_type, :observation]
      ],
      trends: [
        :location, :standard, :trend_observations, :reference
      ]
    ).friendly.find params[:id]
    observations = @specie.observations
      .joins(:import)
      .where('imports.aasm_state': 'imported')
    @grouped_measurements = Measurement.where(observation: observations)
      .group_by(&:trait_class)
    @trends = @specie.trends
  end
end
