class PagesController < PreAuthController
  def start
    @measurement_count = Measurement.count
    @trait_count       = Trait.count
    @species_count     = Species.count
  end

  def about
  end

  def procedure
  end

  def contact
  end
end
