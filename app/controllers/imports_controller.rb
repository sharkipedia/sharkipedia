class ImportsController < ApplicationController
  def show
    @import = current_user.imports.find params[:id]
  end

  def index
    @imports = current_user.imports
  end

  def new
    @import = current_user.imports.new
  end

  def create
    import = current_user.imports.create!(import_params)
    ImportValidatorJob.perform_later import

    redirect_to import_path(import)
  end

  def approve
    # TODO: add policy check
    import = Import.find params[:import_id]
    import.approved_by = current_user
    import.approve!
    redirect_to import_path(import)
  end

  def request_changes
    # TODO: add policy check
    import = Import.find params[:import_id]
    import.request_changes!
    redirect_to import_path(import)
  end

  def reject
    # TODO: add policy check
    import = Import.find params[:import_id]
    import.reject!
    redirect_to import_path(import)
  end

  # TODO: Add endpoint to change the visibility of an imported dataset (i.e.
  # make it public / hide)

  private

  def import_params
    params.require(:import).permit(:xlsx_file, :import_type, :title)
  end
end
