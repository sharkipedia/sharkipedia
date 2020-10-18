module Export
  class Trends < ApplicationService
    def initialize(trends = nil)
      @trends = trends || Trend.all
    end

    def call
      CSV.generate do |csv|
        header = %w[
          Class Order Family Genus Species Binomial IUCNcode SourceYear
          Taxonomic Notes AuthorYear DataSource doi
        ]

        years = TrendObservation.pluck(:year).uniq.sort
        header += years

        header += %w[
          Units SamplingMethod SamplingMethodCode Location Latitude Longitude
          Ocean DataType NoYears TimeMin PageAndFigureNumber LineUsed PDFPage
          ActualPage Depth Model FigureName FigureData
        ]

        csv << header

        @trends.each do |trend|
          trend.trend_observations.each do |observation|
            data = [
              trend.species.species_subclass.name,
              trend.species.species_superorder.name,
              trend.species.species_family.name,
              nil,
              trend.species.name,
              trend.species.iucn_code,
              trend.reference.year,
              trend.taxonomic_notes,
              trend.reference.name,
              trend.reference.data_source,
              trend.reference.doi
            ]

            data += trend.trend_observations.pluck(:year, :value).sort.to_h
              .values_at(*years)

            data += [
              trend.standard.name,
              trend.sampling_method.name,
              trend.sampling_method.code,
              trend.location.name,
              trend.location.latitude,
              trend.location.longitude,
              trend.oceans.map(&:name).join(","),
              trend.data_type.name,
              trend.no_years,
              trend.time_min,
              trend.page_and_figure_number,
              trend.line_used,
              trend.pdf_page,
              trend.actual_page,
              trend.depth,
              trend.model,
              trend.figure_name,
              trend.figure_data
            ]
            csv << data
          end
        end
      end
    end
  end
end
