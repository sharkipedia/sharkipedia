class TrendsController < ApplicationController
  before_action :ensure_admin!

  def index
    @trends = Export::Trends.new.call
  end

  def new
    @example_specie = Species.find_by name: 'Carcharhinus acronotus'
    @example_resource = Resource.find_by name: 'everett2015'
    @trend = current_user.trends.new
  end

  def show
    @trend = Trend.find params[:id]
  end

  def create
    @trend = current_user.trends.new(trend_params)

    if @trend.save
      redirect_to @trend
    else
      render :new
    end
  end

  private

  def trend_params
    params.require(:trend).permit(
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
      trend_observations_attributes: [ :id, :url, :alt, :caption ],
      variants_attributes: [ :id, :name, :price, :_destroy ]
    )
  end
end
