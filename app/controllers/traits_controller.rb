class TraitsController < PreAuthController
  include Pagy::Backend

  def index
    # TODO: cache these calculations
    @measurement_count = Measurement.count
    @trait_count       = Measurement.joins(:trait).select(:trait_id).distinct.count
    @species_count     = Observation.joins(:species).select(:species_id).distinct.count

    @trait_classes = TraitClass.all
  end

  def show
    @trait = Trait.find params[:id]
  end
end
