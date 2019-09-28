class ObservationsController < ApplicationController
  include Pagy::Backend
  before_action :set_observation, only: [:show, :edit, :update, :destroy]

  def index
    @observations = current_user.observations
  end

  def show
  end

  def new
    @observation = current_user.observations.new

    @example_species = Species.find_by name: 'Carcharhinus acronotus'
    @example_resource = Resource.find_by name: 'driggers2004a'

    @standards = Standard.all
    @sampling_methods = SamplingMethod.all
    @measurement_models = MeasurementModel.all
    @data_types = DataType.all
    @oceans = Ocean.all
    @locations = Location.all
  end

  def edit
  end

  def create
    @observation = current_user.observations.new(observation_params)

    respond_to do |format|
      if @observation.save
        format.html { redirect_to @observation, notice: 'Observation was successfully created.' }
        format.js { redirect_to @trend }
      else
        format.html do
          @example_species = Species.find_by name: 'Carcharhinus acronotus'
          @example_resource = Resource.find_by name: 'driggers2004a'

          @standards = Standard.all
          @sampling_methods = SamplingMethod.all
          @measurement_models = MeasurementModel.all
          @data_types = DataType.all
          @oceans = Ocean.all
          @locations = Location.all

          render :new
        end
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @observation.update(observation_params)
        format.html { redirect_to @observation, notice: 'Observation was successfully updated.' }
        format.json { render :show, status: :ok, location: @observation }
      else
        format.html { render :edit }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @observation.destroy
    respond_to do |format|
      format.html { redirect_to observations_url, notice: 'Observation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_observation
      @observation = current_user.observations.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def observation_params
      params.require(:observation).permit(
        :species_id, :date, :access, :hidden, :user_id,
        :contributor_id, :depth,
        measurement_attributes: [ :id,
                                  :_destroy,
                                  :sex_type_id,
                                  :trait_class_id,
                                  :trait_id,
                                  :standard_id,
                                  :measurement_method_id,
                                  :measurement_model_id,
                                  :value,
                                  :value_type_id,
                                  :precision,
                                  :precision_type_id,
                                  :precision_upper,
                                  :sample_size,
                                  :dubious,
                                  :validated,
                                  :notes,
                                  :validation_type_id,
                                  :location_id,
                                  :longhurst_province_id, ],
      )
    end
end
