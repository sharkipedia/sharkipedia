class ImportsController < ApplicationController
  def show
    @import = Import.find params[:id]
  end

  def index
    @imports = Import.all
  end

  def new
    @import = Import.new
  end

  def create
    import = current_user.imports.create!(import_params)

    redirect_to import_path(import)
  end

  private

  def import_params
    params.require(:import).permit(:xlsx_file, :import_type, :title)
  end
end
