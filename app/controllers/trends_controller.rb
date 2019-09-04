class TrendsController < ApplicationController
  before_action :ensure_admin!

  def index
    @trends = Trend.all
  end

  def new
    @example_specie = Species.find_by name: 'Carcharhinus acronotus'
    @example_resource = Resource.find_by name: 'everett2015'

    @trend = current_user.trends.new
    @trend.location = Location.new

    @standards = Standard.all
    @sampling_methods = SamplingMethod.all
    @measurement_models = MeasurementModel.all
    @data_types = DataType.all
    @oceans = Ocean.all
    @locations = Location.all
  end

  def show
    @trend = Trend.find params[:id]

    respond_to do |format|
      format.html
      format.csv { send_data @trend.to_csv,
                   filename: "#{@trend.resource.name}.csv" }
    end
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
          @example_specie = Species.find_by name: 'Carcharhinus acronotus'
          @example_resource = Resource.find_by name: 'everett2015'
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

  private

  def trend_params
    params.require(:trend).permit(
      :species_id,
      :resource_id,
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
