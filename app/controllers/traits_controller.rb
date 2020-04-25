class TraitsController < PreAuthController
  include Pagy::Backend

  def index
    @trait_classes = TraitClass.includes(:traits).all
  end

  def show
    @trait = Trait.includes(measurements: [
      :standard,
      :value_type,
      :location,
      observation: [
        :species,
        :references
      ]
    ]).find params[:id]

    observations = Observation
      .joins(:import, :measurements)
      .where('imports.aasm_state': "imported", 'measurements.trait_id': @trait)

    @measurements = @trait.measurements.where(observation: observations)
  end
end
