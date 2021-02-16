class TraitsController < PreAuthController
  include Pagy::Backend

  def index
    @trait_classes = TraitClass.includes(:traits).all
  end

  def show
    @trait = Trait.find params[:id]

    observations = Observation
      .joins(:import, :measurements)
      .where('imports.aasm_state': "imported", 'measurements.trait_id': @trait)

    @measurements = @trait.measurements.includes(
      [
        :standard,
        :value_type,
        :location,
        observation: [
          :species,
          :references
        ]
      ]
    ).order("species.name, \"references\".name").where(observation: observations)
  end
end
