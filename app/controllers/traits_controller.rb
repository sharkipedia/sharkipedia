class TraitsController < PreAuthController
  def index
    observations = current_user.try(:editor?) ? Observation.all : nil
    @traits = Export::Traits.new(observations).call

    respond_to do |format|
      format.html
      format.csv { send_data @traits, filename: "traits-#{Date.today}.csv" }
    end
  end
end
