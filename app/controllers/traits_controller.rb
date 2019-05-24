class TraitsController < PreAuthController
  def index
    @measurement_count = Measurement.count
    @trait_count       = Measurement.joins(:trait).select(:trait_id).distinct.count #Trait.count
    @species_count     = Observation.joins(:species).select(:species_id).distinct.count
    observations = current_user.try(:editor?) ? Observation.all : nil
    @traits = Export::Traits.new(observations).call
  end
end
