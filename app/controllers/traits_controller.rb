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
        :species
      ]
    ]).find params[:id]
  end
end
