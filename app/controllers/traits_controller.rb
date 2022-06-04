class TraitsController < PreAuthController
  include Pagy::Backend

  def index
    @trait_classes = TraitClass.includes(:traits).all
  end

  def show
    @trait = Trait.find params[:id]

    observations = Observation
      .joins(:import, :measurements)
      .where("imports.aasm_state": "imported", "measurements.trait_id": @trait)

    order = if params[:order] == "references"
      "\"references\".name, species.name"
    else
      "species.name, \"references\".name"
    end

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
    ).order(order).where(observation: observations)
  end
end
