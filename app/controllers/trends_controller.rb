class TrendsController < PreAuthController
  include Pagy::Backend

  before_action :set_trend, only: [:show, :destroy]
  before_action :set_associations, only: [:new, :edit, :create, :update]

  def index
    (@filterrific = initialize_filterrific(
      policy_scope(Trend),
      params[:filterrific],
      persistence_id: false
    )) || return

    @pagy, @trends = pagy(@filterrific.find)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @trend = current_user.trends.new
    @trend.location = Location.new
    authorize @trend
  end

  def show
    authorize @trend
    @meow_regions = @trend.marine_ecoregions_worlds.meow.map(&:trend_reg_id)
    @ppow_regions = @trend.marine_ecoregions_worlds.ppow.map(&:trend_reg_id)

    respond_to do |format|
      format.html
      format.csv {
        send_data @trend.to_csv,
          filename: "#{@trend.reference.name}.csv"
      }
    end
  end

  def edit
    @trend = Trend.find params[:id]
    authorize @trend
  end

  def create
    trend_observations = JSON.parse(params[:trend].delete(:trend_observations_attributes))

    @trend = current_user.trends.new(trend_params)

    authorize @trend

    import = current_user.imports.create title: @trend.title, import_type: "trend"
    import.do_validate

    @trend.import = import
    success = @trend.save
    @trend.create_or_update_observations(trend_observations) if success

    respond_to do |format|
      if success
        # NOTE: we redirect_to the import _NOT_ the trend
        format.html { redirect_to import }
        format.js { redirect_to import }
      else
        format.html do
          render :new
        end
        format.js
      end
    end
  end

  def update
    @trend = Trend.find params[:id]
    authorize @trend

    trend_observations = JSON.parse(params[:trend].delete(:trend_observations_attributes))
    @trend.create_or_update_observations(trend_observations)

    marine_ecoregions_world_ids = [
      params.fetch(:trend).delete(:ppow_region_ids),
      params.fetch(:trend).delete(:meow_region_ids)
    ].flatten

    params[:trend][:marine_ecoregions_world_ids] = marine_ecoregions_world_ids

    success = @trend.update(trend_params)

    respond_to do |format|
      if success
        format.html { redirect_to @trend }
        format.js { redirect_to @trend }
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trend
    @trend = policy_scope(Trend).find params[:id]
  end

  def set_associations
    @example_species = Species.first
    @example_reference = Reference.first

    @standards = Standard.all
    @sampling_methods = SamplingMethod.all
    @measurement_models = MeasurementModel.all
    @data_types = DataType.all
    @oceans = Ocean.all
    @meow_regions = MarineEcoregionsWorld.meow
    @ppow_regions = MarineEcoregionsWorld.ppow
    @fao_areas = FaoArea.all
    @longhurst_provinces = LonghurstProvince.all
  end

  def trend_params
    params.require(:trend).permit(
      :species_id,
      :reference_id,
      :start_year,
      :end_year,
      :no_years,
      :time_min,
      :comments,
      :page_and_figure_number,
      :line_used,
      :pdf_page,
      :actual_page,
      :depth,
      :analysis_model_id,
      :figure_name,
      :figure_data,
      :figure,
      :standard_id,
      :unit_time_id,
      :unit_spatial_id,
      :unit_gear_id,
      :unit_transformation_id,
      :unit_freeform,
      :sampling_method_info,
      :dataset_representativeness_experts,
      :experts_for_representativeness,
      :dataset_map,
      :variance,
      :data_mined,
      :data_type_id,
      :sampling_method_id,
      ocean_ids: [],
      fao_area_ids: [],
      marine_ecoregions_world_ids: [],
      location_attributes: [:id, :name, :lat, :lon]
    )
  end
end
