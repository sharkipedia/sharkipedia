class PagesController < PreAuthController
  def start
    @measurement_count = Measurement.count
    @trait_count       = Measurement.joins(:trait).select(:trait_id).distinct.count #Trait.count
    @species_count     = Observation.joins(:species).select(:species_id).distinct.count

    @trait_classes = TraitClass.all
  end

  def about
    @editors = User.editors
    @contributors = User.contributors
  end

  def procedure
  end

  def contact
  end
end
