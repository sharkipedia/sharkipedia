class TrendsController < ApplicationController
  before_action :ensure_admin!
  before_action :set_trend, only: [:show, :edit, :update, :destroy]
  before_action :set_associations, only: [:new, :edit, :create, :update]

  def index
    @trends = Trend.all
  end

  def new
    @trend = current_user.trends.new
    @trend.location = Location.new
  end

  def show
    respond_to do |format|
      format.html
      format.csv { send_data @trend.to_csv,
                   filename: "#{@trend.reference.name}.csv" }
    end
  end

  def edit
  end

  def create
    location = Location.find_or_create_by name: params[:trend][:location][:name],
      lat: params[:trend][:location][:lat],
      lon: params[:trend][:location][:lon]
    @trend = current_user.trends.new(trend_params)
    @trend.location = location

    respond_to do |format|
      if @trend.save
        format.html { redirect_to @trend }
        format.js { redirect_to @trend }
      else
        format.html do
          render :new
        end
        format.js
      end
    end
  end

  def update
    location = Location.find_or_create_by name: params[:trend][:location][:name],
      lat: params[:trend][:location][:lat],
      lon: params[:trend][:location][:lon]

    @trend.location = location

    respond_to do |format|
      if @trend.update(trend_params)
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
    @trend = Trend.find params[:id]
  end

  def set_associations
    @example_species = Species.find_by name: 'Carcharhinus acronotus'
    @example_reference = Reference.find_by name: 'everett2015'

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
      :sampling_method_id,
      trend_observations_attributes: [ :id, :year, :value, :_destroy ],
    )
  end
end
