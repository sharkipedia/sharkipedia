class ObservationsController < ApplicationController
  include Pagy::Backend
  before_action :set_observation, only: [:show, :edit, :update, :destroy]
  before_action :set_associations, only: [:new, :edit, :create, :update]

  def index
    @pagy, @observations = pagy(policy_scope(Observation))
  end

  def show
    @species = @observation.species
    @references = @observation.references
    @measurements = @observation.measurements
  end

  def new
    @observation = current_user.observations.new
    authorize @observation
  end

  def edit
    authorize @observation
  end

  def create
    @observation = current_user.observations.new(observation_params)
    authorize @observation

    respond_to do |format|
      if @observation.save
        format.html { redirect_to @observation, notice: 'Observation was successfully created.' }
        format.js { redirect_to @observation }
      else
        format.html do
          render :new
        end
        format.js
      end
    end
  end

  def update
    authorize @observation
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
    authorize @observation
    @observation.destroy
    respond_to do |format|
      format.html { redirect_to observations_url, notice: 'Observation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_observation
    @observation = policy_scope(Observation).find params[:id]
  end

  def set_associations
    @example_species = Species.find_by name: 'Carcharhinus acronotus'
    @example_reference = Reference.find_by name: 'driggers2004a'

    @sex_types = SexType.all
    @trait_classes = TraitClass.all

    @references = Reference.all

    @standards = Standard.all
    @sampling_methods = SamplingMethod.all
    @measurement_methods = MeasurementMethod.all
    @measurement_models = MeasurementModel.all
    @data_types = DataType.all
    @value_types = ValueType.all
    @precision_types = PrecisionType.all
    @validation_types = ValidationType.all
    @longhurst_provinces = LonghurstProvince.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def observation_params
    params.require(:observation).permit(
      :species_id, :access, :hidden, :user_id, :depth,
      reference_ids: [],
      measurements_attributes: [ :id,
                                :_destroy,
                                :date,
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
                                :longhurst_province_id,
                                location_attributes: [:name, :lat, :lon],
    ],
    )
  end
end
