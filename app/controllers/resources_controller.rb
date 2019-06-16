class ResourcesController < PreAuthController
  include Pagy::Backend

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
end
