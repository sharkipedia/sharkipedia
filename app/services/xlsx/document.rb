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

    def data_sheet
      return @sheet unless @sheet.blank?

      title = xlsx.sheets.select { |s| s =~ /data/i }.first
      sheet = xlsx.sheet title
      parsed = sheet.parse(headers: true)
      parsed.shift # remove the header row
      @sheet = parsed
    end
  end
end
