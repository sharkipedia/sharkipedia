class ProtectedSpeciesController < PreAuthController
  def index
    @species = policy_scope(Species.protected_species).includes(:species_order, :species_family).order("species_order.name, species_families.name, species.name")
    @species_orders = @species.map { |s| s.species_order.name }.uniq
    @species_families = @species.map { |s| s.species_family.name }.uniq.sort

    if filtered_by_order?
      @species = @species.where(species_order: {name: params[:filter][:order]})
      @species_families = @species.map { |s| s.species_family.name }.uniq.sort
      @current_order = params[:filter][:order]
    end

    if filtered_by_family?
      @species = @species.where(species_families: {name: params[:filter][:family]})
      @species_orders = @species.map { |s| s.species_order.name }.uniq
    end
  end

  private

  def filtered_by_order?
    params.dig :filter, :order
  end

  def filtered_by_family?
    params.dig :filter, :family
  end
end
