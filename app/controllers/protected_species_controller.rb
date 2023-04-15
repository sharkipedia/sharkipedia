class ProtectedSpeciesController < PreAuthController
  def index
    @species = policy_scope(Species).where.not(cms_status: 0).or(policy_scope(Species).where.not(cites_status: 0)).includes(:species_order, :species_family).order("species_order.name, species_families.name, species.name")

    @species_orders = @species.map { |s| s.species_order.name }.uniq

    if params.dig :filter, :order
      @species = @species.where(species_order: {name: params[:filter][:order]})
    end
  end
end
