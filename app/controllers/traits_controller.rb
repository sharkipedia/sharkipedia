class TraitsController < PreAuthController
  def index
    observations = current_user.try(:editor?) ? Observation.all : nil
    @traits = Export::Traits.new(observations).call
  end
end
