class SpeciesController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @species = pagy(Species.all)
  end

  def show
    @specie = Species.find params[:id]
    @grouped_measurements = Measurement.where(observation: @specie.observations)
                                       .group_by(&:trait_class)
  end
end
