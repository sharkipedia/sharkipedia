class TrendsController < PreAuthController
  include Pagy::Backend

  before_action :set_trend, only: [:show, :destroy]
  before_action :set_associations, only: [:new, :edit, :create, :update]

  def index
    @pagy, @trends = pagy(policy_scope(Trend))
  end

  def new
    @trend = current_user.trends.new
    @trend.location = Location.new
    authorize @trend
  end

  def show
    authorize @trend
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
    location_params = params[:trend].delete(:location)
    location = Location.find_or_create_by name: location_params[:name],
                                          lat: location_params[:lat],
                                          lon: location_params[:lon]

    trend_observations = JSON.parse(params[:trend].delete(:trend_observations_attributes))

    @trend = current_user.trends.new(trend_params)

    authorize @trend

    import = current_user.imports.create title: @trend.title, import_type: "trend"
    import.do_validate

    @trend.location = location
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

    location_params = params[:trend].delete(:location)
    location = Location.find_or_create_by name: location_params[:name],
                                          lat: location_params[:lat],
                                          lon: location_params[:lon]

    @trend.location = location

    trend_observations = JSON.parse(params[:trend].delete(:trend_observations_attributes))
    @trend.create_or_update_observations(trend_observations)

    success = @trend.update(trend_params)

    respond_to do |format|
      if success
        format.html { redirect_to @trend.import }
        format.js { redirect_to @trend.import }
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
  end

  def trend_params
    params.require(:trend).permit(
      :species_id,
      :reference_id,
      :start_year,
      :end_year,
      :no_years,
      :time_min,
      :taxonomic_notes,
      :page_and_figure_number,
      :line_used,
      :pdf_page,
      :actual_page,
      :depth,
      :model,
      :figure_name,
      :figure_data,
      :figure,
      :ocean_id,
      :standard_id,
      :data_type_id,
      :sampling_method_id
    )
  end
end
