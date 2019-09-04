class ResourcesController < PreAuthController
  include Pagy::Backend

  def new
    ensure_admin!

    @resource = Resource.new
  end

  def create
    ensure_admin!

    @resource = Resource.new resource_params
    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource }
        format.js { redirect_to @resource }
      else
        format.html { render :new }
        format.js
      end
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
