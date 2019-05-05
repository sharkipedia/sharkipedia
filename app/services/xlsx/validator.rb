module Xlsx
  class Validator < ApplicationService
    attr_reader :type, :xlsx, :trait, :trend

    Result = Struct.new(:type, :valid, :messages)

    TRAIT_TEMPLATE = 'docs/SharkTraits-Template.xlsx'
    TREND_TEMPLATE = 'docs/SharkTrends-Template.xlsx'

    def initialize(file_path)
      @messages = []
      @valid = false
      begin
        @xlsx = Xlsx::Document.new(file_path)
      rescue ArgumentError
        @messages << "Document is not an Excel sheet."
        @type = :invalid
      end

      @trait = Document.new(TRAIT_TEMPLATE)
      @trend = Document.new(TREND_TEMPLATE)
    end

    def call
      guess_type

      unless type == :invalid
        validate_column_headers

        @xlsx.data_sheet.each_with_index do |row, idx|
          validate_resources row, idx
          validate_species row, idx
        end
      end

      return Result.new @type, @valid, @messages
    end

    def guess_type
      return unless @xlsx

      if xlsx.sheets == trend.sheets
        @type = :trends
        @messages << "Document is a 'Trends' dataset."
      elsif !(xlsx.sheets & trend.sheets).empty?
        @type = :trends
        @messages << "Document is probably 'Trends' dataset."
      elsif xlsx.sheets == trait.sheets
        @type = :traits
        @messages << "Document is a 'Traits' dataset."
      elsif !(xlsx.sheets & trait.sheets).empty?
        @type = :traits
        @messages << "Document is probably 'Traits' dataset."
      else
        @type = :invalid
        @messages << 'Document type could not be detected.'
        @messages << 'Validation failed. The document can\'t be imported.'
        @valid = false
      end
    end

    def validate_column_headers
      template = case type
                 when :traits
                   @trait
                 when :trends
                   @trend
                 end

      if @xlsx.headers == template.headers
        @messages << "Data-Sheet column headers are valid."
        @valid = true
      else
        missing = template.headers - xlsx.headers
        @messages << "Data-Sheet column headers #{missing} are missing."
      end
    end

    def validate_resources row, idx
      name = (row['resource_name'] || row['AuthorYear']).try(:strip)
      return if Resource.find_by name: name

      resource = Resource.new name: name,
        data_source: row['DataSource'].try(:strip),
        doi: (row['resource_doi'] || row['doi']).try(:strip),
        year: row['SourceYear']

      unless resource.valid?
        @valid = false
        resource.errors.full_messages.each do |message|
          # 0 index + row 1 are headers
          @messages << "Row #{idx + 2}: Resource #{message}"
        end
      end
    end

    def validate_species row, idx
      species_name = row['species_name'] || row['Species name']
      if species_name.blank?
        @valid = false
        @messages << "Row #{idx + 2}: No species given."
      else
        species = Species.find_by name: species_name
        species ||= Species.find_by edge_scientific_name: species_name
        unless species
          @valid = false
          @messages << "Row #{idx + 2}: Species '#{species_name}' not found in database."
        end
      end
    end
  end
end
