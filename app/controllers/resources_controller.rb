class ResourcesController < PreAuthController
  include Pagy::Backend

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new resource_params
    if @resource.save
      redirect_to @resource
    else
      render :new
    end
  end

  def index
    resources = if params[:all]
                Resource.all
              else
                Resource.joins(:observations).order(:name).distinct
              end
    @pagy, @resources = pagy(resources)
  end

  def show
    @resource = Resource.find params[:id]
    @observations = @resource.observations
  end

  private

  def resource_params
    params.require(:resource).permit(:name, :doi, :data_source, :year,
                                     :suffix, :author_year, :resource,
                                     :file_public, :resource_file)
  end
end
