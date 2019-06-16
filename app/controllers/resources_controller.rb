class ResourcesController < PreAuthController
  include Pagy::Backend

  def index
    @pagy, @resources = pagy(Resource.all)
  end

  def show
    @resource = Resource.find params[:id]
    @observations = @resource.observations
  end
end
