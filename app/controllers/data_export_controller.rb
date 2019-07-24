class DataExportController < PreAuthController
  def index
    if params[:commit]
      data, exporter = if params[:export_type] == 'Traits'
                          [Observation.all, Export::Traits]
                        else
                          [Trend.all, Export::Trends]
                        end

      if params[:species]
        species_ids = params[:species].reject(&:blank?)
        unless species_ids.blank?
          data = data.where species_id: params[:species]

          @species = Species.where id: species_ids
        end
      end

      if params[:oceans]
        # TODO: try to match ocean with lat, long / Longhurst code - boundaries
        ocean_ids = params[:oceans].reject(&:blank?)
        if !ocean_ids.blank? && params[:export_type] == 'Trends'
          data = data.where ocean_id: ocean_ids
        end
      end

      @data = exporter.new(data).call
    end
  end
end
