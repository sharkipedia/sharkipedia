class ReferencesController < PreAuthController
  include Pagy::Backend

  def new
    ensure_admin!

    @reference = Reference.new
  end

  def create
    ensure_admin!

    @reference = Reference.new reference_params
    respond_to do |format|
      if @reference.save
        format.html { redirect_to @reference }
        format.js { redirect_to @reference }
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def index
    references = if params[:all]
                Reference.all
              else
                Reference.joins(:observations).order(:name).distinct
              end
    @pagy, @references = pagy(references)
  end

  def show
    @reference = Reference.find params[:id]
    @observations = @reference.observations
    @trends = @reference.trends
  end

  private

  def reference_params
    params.require(:reference).permit(:name, :doi, :data_source, :year,
                                     :suffix, :author_year, :reference,
                                     :file_public, :reference_file)
  end
end
