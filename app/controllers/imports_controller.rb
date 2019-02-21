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
    import = Import.find params[:import_id]
    import.approve!
    redirect_to import_path(import)
  end

  def request_changes
    import = Import.find params[:import_id]
    import.request_changes!
    redirect_to import_path(import)
  end

  def reject
    import = Import.find params[:import_id]
    import.reject!
    redirect_to import_path(import)
  end

  private

  def import_params
    params.require(:import).permit(:xlsx_file, :import_type, :title)
  end
end
