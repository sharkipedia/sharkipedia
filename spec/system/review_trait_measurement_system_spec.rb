require "system_helper"

RSpec.describe "Review a trait import" do
  let!(:species) { create(:species, name: "Carcharhinus acronotus") }
  let!(:reference) { create(:reference, name: "driggers2004a") }

  let!(:trait) { create(:trait) }
  let!(:trait_class) { trait.trait_class }
  let!(:sex_type) { create(:sex_type) }
  let!(:standard) { create(:standard, trait_class:) }
  let!(:measurement_method) { create(:measurement_method, trait_class:) }
  let!(:measurement_model) { create(:measurement_model, trait_class:) }
  let!(:longhurst_province) { create(:longhurst_province) }
  let!(:value_type) { create(:value_type) }
  let!(:precision_type) { create(:precision_type) }
  let!(:observation) { create(:observation) }
  let!(:measurement) { create(:measurement, observation:) }

  let(:contributor) { create(:contributor) }
  let!(:import) { create(:traits_import, xlsx_file: nil, observations: [observation], user: contributor) }

  # Import#notify_admins needs at least one admin
  let!(:admin) { create(:admin) }

  it "allows users to review trait imports" do
    sign_in admin

    visit import_path(import)

    expect(page).to have_content(import.title)
    expect(page).to have_content(observation.depth)
    expect(page).to have_content(observation.hidden)
  end
end
