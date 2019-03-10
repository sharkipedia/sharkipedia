class ImportsController < ApplicationController
  def show
    @import = imports.find params[:id]
  end

  def index
    @imports = imports
  end

  def new
    @import = current_user.imports.new
  end

  def edit
    @import = current_user.imports.find params[:id]
  end

  def update
    import = current_user.imports.find params[:id]
    import.update_attributes import_params
    import.resubmit!
    ImportValidatorJob.perform_later import

    redirect_to import_path(import)
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
    import.reason = params[:reason]
    import.request_changes!
    redirect_to import_path(import)
  end

  def reject
    # TODO: add policy check
    import = Import.find params[:import_id]
    import.reason = params[:reason]
    import.reject!
    redirect_to import_path(import)
  end

  # TODO: Add endpoint to change the visibility of an imported dataset (i.e.
  # make it public / hide)

  private

  def imports
    if current_user.editor?
      Import.all
    else
      current_user.imports
    end
  end

  def import_params
    params.require(:import).permit(:xlsx_file, :title)
  end
end
