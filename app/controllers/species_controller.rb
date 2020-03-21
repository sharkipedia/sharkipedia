class SpeciesController < PreAuthController
  include Pagy::Backend

  def index
    species = if params[:all]
      Species.all
    else
      Species.joins(:observations).order(:name).distinct
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
    @grouped_measurements = Measurement.where(observation: @specie.observations)
      .group_by(&:trait_class)
    @trends = @specie.trends
  end
end
