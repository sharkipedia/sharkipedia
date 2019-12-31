require "csv"
require "roo"

if Rails.env.development? || ENV["HEROKU_APP_NAME"] =~ /staging/
  admin = User.new email: "admin@example.com", password: "123123123",
                   name: "Admin", user_level: "admin", confirmed_at: Time.now.utc
  admin.skip_confirmation_notification!
  admin.save!
  admin.confirm
  editor = User.create email: "editor@example.com", password: "123123123",
                       name: "Jane Doe", user_level: "editor", confirmed_at: Time.now.utc
  editor.skip_confirmation_notification!
  editor.save!
  editor.confirm
  contributor = User.create email: "contributor@example.com", password: "123123123",
                            name: "Max Mustermann", user_level: "contributor", confirmed_at: Time.now.utc
  contributor.skip_confirmation_notification!
  contributor.save!
  contributor.confirm
  user = User.create email: "user@example.com", password: "123123123",
                     name: "Martha Musterfrau", confirmed_at: Time.now.utc
  user.skip_confirmation_notification!
  user.save!
  user.confirm
end

puts "Shark Traits Seed data"

CSV.foreach("docs/longhurst_provinces.csv", headers: true) do |row|
  LonghurstProvince.find_or_create_by! name: row["Province"], code: row["Code"]
end
puts "# Created #{LonghurstProvince.count} LonghurstProvince"

taxonomy_xlsx = Roo::Spreadsheet.open("docs/SharkTraits - Taxonomy and Changes.xlsx")
taxonomy_data = taxonomy_xlsx.sheet(taxonomy_xlsx.sheets.first)
taxonomy = taxonomy_data.parse(headers: true)
taxonomy.shift # remove the header row

s_sc = taxonomy.map { |row| row["Subclass"] }.uniq
s_sc.each do |name|
  SpeciesSubclass.find_or_create_by! name: name
end
puts "# Created #{SpeciesSubclass.count} SpeciesSubclasses"

s_so = taxonomy.map { |row| [row["Subclass"], row["Superorder"]] }.uniq
s_so.each do |subclass, superorder|
  ss = SpeciesSubclass.find_by name: subclass
  so = SpeciesSuperorder.find_by name: superorder
  if so
    so.species_subclass = ss
    so.save
  else
    SpeciesSuperorder.create! name: superorder, species_subclass: ss
  end
end

puts "# Created #{SpeciesSuperorder.count} SpeciesSuperorders"

s_o = taxonomy.map { |row| [row["Subclass"], row["Superorder"], row["Order"]] }.uniq
s_o.each do |subclass, superorder, order|
  ssc = SpeciesSubclass.find_by name: subclass
  sso = SpeciesSuperorder.find_by name: superorder
  SpeciesOrder.find_or_create_by! name: order, species_superorder_id: sso.id,
                                  species_subclass_id: ssc.id
end

puts "# Created #{SpeciesOrder.count} SpeciesOrders"

s_f = taxonomy.map { |row|
  [row["Subclass"], row["Superorder"],
   row["Order"], row["Family"],]
} .uniq
s_f.each do |subclass, superorder, order, family|
  ssc = SpeciesSubclass.find_by name: subclass
  sso = SpeciesSuperorder.find_by name: superorder
  so = SpeciesOrder.find_by name: order
  SpeciesFamily.find_or_create_by! name: family,
                                   species_superorder_id: sso.id,
                                   species_subclass_id: ssc.id,
                                   species_order_id: so.id
end

puts "# Created #{SpeciesFamily.count} SpeciesFamilies"

s_ds = taxonomy.map { |row| row["Data type"] }.uniq
s_ds.each do |name|
  SpeciesDataType.find_or_create_by! name: name
end

puts "# Created #{SpeciesDataType.count} SpeciesDataTypes"

taxonomy.each do |row|
  ssc = SpeciesSubclass.find_by name: row["Subclass"]
  sso = SpeciesSuperorder.find_by name: row["Superorder"]
  so = SpeciesOrder.find_by name: row["Order"]
  sf = SpeciesFamily.find_by name: row["Family"]
  sdt = SpeciesDataType.find_by name: row["Data type"]
  species = Species.find_by name: row["SharkTrait Scientific name"]
  if species
    species.update species_subclass: ssc, species_superorder: sso,
                   species_order: so, species_family: sf, species_data_type: sdt,
                   authorship: row["Species authorship"]
  else
    Species.create! name: row["SharkTrait Scientific name"],
                    edge_scientific_name: row["EDGE Scientific name"],
                    species_subclass: ssc, species_superorder: sso,
                    species_order: so, species_family: sf, species_data_type: sdt,
                    authorship: row["Species authorship"]
  end
end

puts "# Created #{Species.count} Species"

super_orders = CSV.open("docs/species.csv", &:readline).reject(&:nil?)
CSV.foreach("docs/species.csv", headers: true) do |row|
  super_orders.each do |sok, so|
    species_name = row[sok]
    next if species_name.blank?

    species = Species.find_by name: species_name
    species ||= Species.find_by edge_scientific_name: species_name
    unless species
      puts "Species: #{species.inspect} not present in 'Taxonomy and Changes'"
      puts row.inspect
    end

    # Species.find_or_create_by! name: species_name, species_superorder: so
  end
end
# puts "# Created #{Species.count} Species"

CSV.foreach("docs/sex_types.csv") do |row|
  SexType.find_or_create_by! name: row.first
end

puts "# Created #{SexType.count} SexTypes"

CSV.foreach("docs/value_types.csv") do |row|
  ValueType.find_or_create_by! name: row.first
end

puts "# Created #{ValueType.count} ValueTypes"

CSV.foreach("docs/precision_types.csv") do |row|
  PrecisionType.find_or_create_by! name: row.first
end

puts "# Created #{PrecisionType.count} PrecisionTypes"

%w[Length Age Growth Reproduction Demography Relationships].each do |t|
  TraitClass.find_or_create_by! name: t
end

puts "# Created #{TraitClass.count} TraitClass"

CSV.foreach("docs/traits.csv", headers: true) do |row|
  TraitClass.all.each do |tc|
    name = row[tc.name]
    next if name.blank?
    Trait.find_or_create_by! name: name, trait_class: tc
  end
end

CSV.foreach("docs/traits-descriptions.csv") do |row|
  tc = TraitClass.find_or_create_by name: row.third
  trait = tc.traits.find_by name: row.first
  if trait
    trait.update description: row.second
  else
    puts "#{row.first} not found creating"
    tc.traits.create name: row.first, description: row.second
  end
end

puts "# Created #{Trait.count} Traits"

CSV.foreach("docs/standards.csv", headers: true) do |row|
  TraitClass.all.each do |tc|
    name = row[tc.name]
    next if name.blank?
    Standard.find_or_create_by! name: name, trait_class: tc
  end
end

puts "# Created #{Standard.count} Standards"

CSV.foreach("docs/methods.csv", headers: true) do |row|
  TraitClass.all.each do |tc|
    name = row[tc.name]
    next if name.blank?
    MeasurementMethod.find_or_create_by! name: name, trait_class: tc
  end
end

CSV.foreach("docs/methods-descriptions.csv") do |row|
  tc = TraitClass.find_or_create_by name: row.third
  method = tc.measurement_methods.find_by name: row.first
  if method
    method.update description: row.second
  else
    puts "#{row.first} not found creating"
    tc.measurement_methods.create name: row.first, description: row.second
  end
end

puts "# Created #{MeasurementMethod.count} MeasurementMethods"

CSV.foreach("docs/models.csv", headers: true) do |row|
  TraitClass.all.each do |tc|
    name = row[tc.name]
    next if name.blank?
    MeasurementModel.find_or_create_by! name: name, trait_class: tc
  end
end

CSV.foreach("docs/models-descriptions.csv") do |row|
  tc = TraitClass.find_or_create_by name: row.third
  model = tc.measurement_models.find_by name: row.first
  if model
    model.update description: row.second
  else
    puts "#{row.first} not found creating"
    tc.measurement_models.create name: row.first, description: row.second
  end
end

puts "# Created #{MeasurementModel.count} MeasurementModels"

puts "# Importing References, this can take a few minutes"
failed = []
CSV.foreach("docs/shark-resources-190723.csv", headers: true) do |row|
  resource = Reference.new name: row["resource_id"], reference: row["resource"],
                           year: row["year"], doi: (row["DOI"] == "NA" ? nil : row["DOI"]),
                           suffix: row["suffix"], data_source: row["source"]
  resource.save!
rescue
  failed.push row["resource_id"]
end

puts "# Created #{Reference.count} References"

puts "Shark Trends Seed data"

CSV.foreach("docs/units.csv") do |row|
  Standard.find_or_create_by! name: row.first
end

CSV.foreach("docs/standards-descriptions.csv") do |row|
  tc = TraitClass.find_or_create_by name: row.third
  standard = tc.standards.find_by name: row.first
  if standard
    standard.update description: row.second
  else
    puts "#{row.first} not found creating"
    tc.standards.create name: row.first, description: row.second
  end
end

puts "# Created #{Standard.count} Standards"

CSV.foreach("docs/sampling_methods.csv") do |row|
  SamplingMethod.find_or_create_by! name: row.first
end

puts "# Created #{SamplingMethod.count} SamplingMethods"

CSV.foreach("docs/oceans.csv") do |row|
  Ocean.find_or_create_by! name: row.first
end

puts "# Created #{Ocean.count} Oceans"

CSV.foreach("docs/data_types.csv") do |row|
  DataType.find_or_create_by! name: row.first
end

puts "# Created #{DataType.count} DataTypes"
