module Xlsx
  class Document
    attr_reader :xlsx

    def initialize file_path
      @xlsx = Roo::Spreadsheet.open(file_path)
    end

    def sheets
      @sheets ||= xlsx.sheets
    end

    def headers
      @headers ||= xlsx.sheet(xlsx.sheets.first).row(1).map(&:to_s).map(&:strip)
    rescue
      []
    end
  end
end
