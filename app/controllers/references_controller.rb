class ReferencesController < PreAuthController
  include Pagy::Backend

  def new
    ensure_contributor!

    @reference = Reference.new
  end

  def create
    ensure_contributor!

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
    respond_to do |format|
      format.html do
        @reference = Reference.includes(
          observations: [
            :species, measurements: [:standard, :value_type, :location, :trait]
          ], trends: [:species, :location, :standard, :trend_observations]
        ).friendly.find params[:id]

        @observations = @reference.observations.joins(:import)
          .where("imports.aasm_state": "imported")
        @trends = Trend.joins(:import).where(reference: @reference,
          "imports.aasm_state": "imported")
      end

      format.js do
        @reference = Reference.friendly.find params[:id]
      end
    end
  end

  private

  def reference_params
    params.require(:reference).permit(:name, :doi, :data_source, :year,
      :suffix, :author_year, :reference,
      :file_public, :reference_file)
  end
end
