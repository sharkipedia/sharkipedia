class ProtectedSpeciesController < PreAuthController
  def index
    @species = policy_scope(Species.protected_species)
    @species_orders = @species.map { |s| s.species_order.name }.uniq
    @species_families = @species.map { |s| s.species_family.name }.uniq.sort
    if (@current_order = params.dig(:filter, :order))
      @species = @species.where(species_order: {name: @current_order})
      @species_families = @species.map { |s| s.species_family.name }.uniq.sort
    end

    if (@current_family = params.dig(:filter, :family))
      @species = @species.where(species_families: {name: @current_family})
      @species_orders = @species.map { |s| s.species_order.name }.uniq
    end
  end
end
