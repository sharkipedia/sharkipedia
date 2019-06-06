class SpeciesController < ApplicationController
  include Pagy::Backend

  def index
    species = if params[:all]
                Species.all
              else
                Species.joins(:observations)
              end

    @pagy, @species = pagy(species)
  end

  def show
    @specie = Species.find params[:id]
    @grouped_measurements = Measurement.where(observation: @specie.observations)
                                       .group_by(&:trait_class)
  end
end
