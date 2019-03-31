require 'csv'
require 'roo'

puts "Shark Traits Seed data"

CSV.foreach('docs/longhurst_provinces.csv', headers: true) do |row|
  LonghurstProvince.find_or_create_by! name: row['Province'], code: row['Code']
end
puts "# Created #{LonghurstProvince.count} LonghurstProvince"

taxonomy_xlsx = Roo::Spreadsheet.open('docs/SharkTraits - Taxonomy and Changes.xlsx')
taxonomy_data = taxonomy_xlsx.sheet(taxonomy_xlsx.sheets.first)
taxonomy      = taxonomy_data.parse(headers: true)

# Species Data Types
s_ds = taxonomy.map { |row| row['Data type'] }.uniq
s_ds.each do |name|
  SpeciesDataType.create! name: name
end


super_orders = CSV.open('docs/species.csv', &:readline).reject(&:nil?)
super_orders = super_orders.map do |super_order|
  [
    super_order, SpeciesSuperorder.find_or_create_by!(name: super_order)
  ]
end.to_h
puts "# Created #{SpeciesSuperorder.count} apeciesSuperorders"

CSV.foreach('docs/species.csv', headers: true) do |row|
  super_orders.each do |sok, so|
    species_name = row[sok]
    next if species_name.blank?

    Species.find_or_create_by! name: species_name, species_superorder: so
  end
end
puts "# Created #{Species.count} Species"

CSV.foreach('docs/sex_types.csv') do |row|
  SexType.find_or_create_by! name: row.first
end

puts "# Created #{SexType.count} SexTypes"

CSV.foreach('docs/value_types.csv') do |row|
  ValueType.find_or_create_by! name: row.first
end

puts "# Created #{ValueType.count} ValueTypes"

CSV.foreach('docs/precision_types.csv') do |row|
  PrecisionType.find_or_create_by! name: row.first
end

puts "# Created #{PrecisionType.count} PrecisionTypes"

%w(Length Age Growth Reproduction Demography Relationships).each do |t|
  TraitClass.find_or_create_by! name: t
end

puts "# Created #{TraitClass.count} TraitClass"

CSV.foreach('docs/traits.csv', headers: true) do |row|
  TraitClass.all.each do |tc|
    name = row[tc.name]
    next if name.blank?
    Trait.find_or_create_by! name: name, trait_class: tc
  end
end

puts "# Created #{Trait.count} Traits"

CSV.foreach('docs/standards.csv', headers: true) do |row|
  TraitClass.all.each do |tc|
    name = row[tc.name]
    next if name.blank?
    Standard.find_or_create_by! name: name, trait_class: tc
  end
end

puts "# Created #{Standard.count} Standards"

CSV.foreach('docs/methods.csv', headers: true) do |row|
  TraitClass.all.each do |tc|
    name = row[tc.name]
    next if name.blank?
    MeasurementMethod.find_or_create_by! name: name, trait_class: tc
  end
end

puts "# Created #{MeasurementMethod.count} MeasurementMethods"

CSV.foreach('docs/models.csv', headers: true) do |row|
  TraitClass.all.each do |tc|
    name = row[tc.name]
    next if name.blank?
    MeasurementModel.find_or_create_by! name: name, trait_class: tc
  end
end

puts "# Created #{MeasurementModel.count} MeasurementModels"


puts "Shark Trends Seed data"

CSV.foreach('docs/units.csv') do |row|
  Standard.find_or_create_by! name: row.first
end

puts "# Created #{Standard.count} Standards"

CSV.foreach('docs/sampling_methods.csv') do |row|
  SamplingMethod.find_or_create_by! name: row.first
end

puts "# Created #{SamplingMethod.count} SamplingMethods"

CSV.foreach('docs/oceans.csv') do |row|
  Ocean.find_or_create_by! name: row.first
end

puts "# Created #{Ocean.count} Oceans"

CSV.foreach('docs/data_types.csv') do |row|
  DataType.find_or_create_by! name: row.first
end

puts "# Created #{DataType.count} DataTypes"
