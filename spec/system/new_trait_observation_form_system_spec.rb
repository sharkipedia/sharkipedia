require "system_helper"

RSpec.describe "New Trait Observation form" do
  let(:contributor) { create(:contributor) }

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

  let!(:admin) { create(:admin) }

  def fill_measurement(value)
    select2 species.name, from: "Species"
    fill_in "Date", with: "2020"
    select2 trait_class.name, from: "Trait class"
    select2 trait.name, xpath: ".//div[label[text()='Trait']]"
    select2 sex_type.name, from: "Sex type"
    select2 standard.name, from: "Standard"
    select2 measurement_method.name, from: "Measurement method"
    select2 measurement_model.name, from: "Measurement model"
    fill_in "Location Name", with: "Test Location"
    fill_in "Latitude", with: "1"
    fill_in "Longitude", with: "1"
    select2 longhurst_province.name, from: "Longhurst province"
    select2 value_type.name, from: "Value type"
    fill_in "Value", with: value
    select2 precision_type.name, from: "Precision type"
    fill_in "Precision", with: "1"
    fill_in "Precision upper", with: "4"
    fill_in "Sample size", with: "100"
    check "Validated"
    fill_in "Notes", with: "I have something to say about this"
  end

  it "allows users to create new observations" do
    sign_in contributor

    visit new_observation_path

    select2 reference.name, css: "#reference_selector", search: true
    fill_in "Depth", with: "100"

    check "hidden"
    # Measurement #1
    click_link "Add Measurement"
    within(:xpath, "//fieldset[@class='measurement'][1]") do
      fill_measurement 10
    end

    # Measurement #2
    click_link "Add Measurement"
    within(:xpath, "//fieldset[@class='measurement'][2]") do
      fill_measurement 20
    end

    click_button "Create Observation"

    sleep 0.2

    expect(page).to have_content("State: pending review")

    import = contributor.imports.first

    expect(import).to be_pending_review

    visit traits_path

    expect(page).not_to have_content(import.title)

    import.approved_by = admin
    import.approve!

    sleep 0.1

    import.reload

    expect(import).to be_imported

    click_button "Publish"

    expect(page).to have_content("Unpublish")

    visit traits_path

    expect(page).to have_content(trait.name)

    click_on trait.name

    expect(page).to have_content(species.name)
    expect(page).to have_content(reference.name)
  end
end
