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
    @specie = Species.find params[:id]
    @grouped_measurements = Measurement.where(observation: @specie.observations)
                                       .group_by(&:trait_class)
  end
end
