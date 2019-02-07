require 'csv'

super_orders = CSV.open('docs/species.csv', &:readline).reject(&:nil?)
super_orders = super_orders.map do |super_order|
  [
    super_order, SpeciesSuperorder.find_or_create_by(name: super_order)
  ]
end.to_h

CSV.foreach('docs/species.csv', headers: true) do |row|
  super_orders.each do |sok, so|
    species_name = row[sok]
    next if species_name.blank?

    Species.create! name: species_name, species_superorder: so
  end
end
