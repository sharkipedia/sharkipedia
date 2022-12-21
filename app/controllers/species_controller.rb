class SpeciesController < PreAuthController
  include Pagy::Backend
  caches_action :show, :index, expires_in: 1.hour

  def index
    species = if params[:all]
      policy_scope(Species)
    else
      policy_scope(Species)
        .joins(observations: :import)
        .where("imports.aasm_state": "imported")
        .order(:name).distinct
    end

    @pagy, @species = pagy(species)
  end

  def show
    @species = Species.includes(
      measurements: [:standard, :value_type, :location, :trait, :sex_type, :observation],
      trends: [
        :location, :standard, :trend_observations, :reference
      ]
    ).friendly.find params[:id]
    observations = @species.observations
      .joins(:import)
      .where("imports.aasm_state": "imported")
    @grouped_measurements = Measurement.where(observation: observations, species: @species)
      .group_by(&:trait_class)
    @trends = @species.trends
    @group_trends = @species.group_trends
    @contributors = observations.map(&:contributor_id).reject(&:blank?)
    @contributors += @trends.map(&:import).map(&:user).map(&:name)
    @contributors = @contributors.uniq

    respond_to do |format|
      format.html
      format.js
      format.csv {
        send_data Export::Traits.new(@species.observations).call,
          filename: "#{@species.name}.csv"
      }
    end
  end
end
