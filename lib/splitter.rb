require 'roo'
require 'rubyXL'

# convenience script that splits a traits document with multiple observations
# into separate documents
# USAGE:
#   rails runner lib/splitter.rb \
#               /Users/max/Downloads/SharkTraits-Template-Example-2.xlsx \
#               /Users/max/SharkTraits

combo_sheet = ARGV[0]
target_location = ARGV[1]

puts combo_sheet
puts target_location
exit

s = Roo::Spreadsheet.open combo_sheet
ds = s.sheet("Data Entry").parse(headers: true, clean: true)
ds.shift

ds.group_by { |row| row['resource_name'] }.each do |resource, rows|
  file = "#{target_location}/#{resource}.xlsx"
  FileUtils.cp 'docs/SharkTraits-Template.xlsx', file
  workbook = RubyXL::Parser.parse(file)
  worksheet = workbook[0]

  rows.each_with_index do |row, row_idx|
    row.values.each_with_index do |value, col_idx|
      worksheet.add_cell(row_idx + 1, col_idx, value)
      # worksheet[row_idx + 1][col_idx].change_contents(value)
    end
  end
  workbook.write(file)
end
