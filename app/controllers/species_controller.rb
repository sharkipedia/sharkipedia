class SpeciesController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @species = pagy(Species.all)
  end

  def show
    @specie = Species.find params[:id]
  end
end
