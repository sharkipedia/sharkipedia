class ImportsController < ApplicationController
  before_action :set_import, only: [:show, :edit, :update, :approve,
    :request_changes, :reject, :request_review]

  def show
    authorize @import
  end

  def index
    imports = case params[:query]
    when "my"
      Import.where(user: current_user)
    when "trait"
      Import.where(import_type: ["trait", "traits"])
    when "trend"
      Import.where(import_type: ["trend", "trends"])
    else
      Import
    end

    @imports = policy_scope(imports.order(created_at: :desc))
  end

  def new
    @import = current_user.imports.new
    authorize @import
  end

  def edit
    authorize @import
  end

  def update
    authorize @import
    import.update_attributes import_params
    import.resubmit!
    ImportValidatorJob.perform_later import

    redirect_to import_path(import)
  end

  def create
    import = current_user.imports.new(import_params)
    authorize import
    import.save!

    ImportValidatorJob.perform_later import

    redirect_to import_path(import)
  end

  def approve
    authorize @import
    @import.approved_by = current_user
    @import.approve!
    redirect_to import_path(@import)
  end

  def request_changes
    authorize @import
    @import.reason = params[:reason]
    @import.request_changes!
    redirect_to import_path(@import)
  end

  def reject
    authorize @import
    @import.reason = params[:reason]
    @import.reject!
    redirect_to import_path(@import)
  end

  def request_review
    authorize @import
    @import.resubmit!
    @import.validate_upload!
    redirect_to import_path(@import)
  end

  # TODO: Add endpoint to change the visibility of an imported dataset (i.e.
  # make it public / hide)

  private

  def set_import
    @import = Import.find(params[:import_id] || params[:id])
  end

  def import_params
    params.require(:import).permit(:xlsx_file, :title)
  end
end
