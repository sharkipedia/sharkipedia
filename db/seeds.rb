require 'csv'


CSV.foreach('docs/longhurst_provinces.csv', headers: true) do |row|
  LonghurstProvince.find_or_create_by! name: row['Province'], code: row['Code']
end
puts "# Created #{LonghurstProvince.count} LonghurstProvince"

super_orders = CSV.open('docs/species.csv', &:readline).reject(&:nil?)
super_orders = super_orders.map do |super_order|
  [
    super_order, SpeciesSuperorder.find_or_create_by!(name: super_order)
  ]
end.to_h
puts "# Created #{SpeciesSuperorder.count} SpeciesSuperorders"

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

%w(Length Age Growth Reproduction Demography Relationships).each do |t|
  TraitClass.find_or_create_by! name: t
end

puts "# Created #{TraitClass.count} TraitClass"
