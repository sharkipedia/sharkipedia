class PagesController < PreAuthController
  def start
    @measurement_count = Measurement.count
    @trait_count = Measurement.joins(:trait).select(:trait_id).distinct.count # Trait.count
    @species_count = Observation.joins(:species).select(:species_id).distinct.count

    @trait_classes = TraitClass.all

    @example_specie = Species.find_by name: "Carcharhinus acronotus"
    @example_trait = Trait.find_by name: "Lmat50"
  end

  def about
    @editors = User.editors
    @contributors = User.contributors
    @contributor_codes = Observation.unscoped.all.select("contributor_id")
      .distinct.map(&:contributor_id)
      .reject(&:blank?)
  end

  def procedure
  end

  def contact
  end

  def api
  end
end
