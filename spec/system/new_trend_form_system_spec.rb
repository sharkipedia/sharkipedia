require "system_helper"

RSpec.describe "New Trend form" do
  let(:contributor) { create(:contributor) }

  let!(:species) { create(:species) }
  let!(:reference) { create(:reference) }

  let!(:ocean) { create(:ocean) }
  let!(:standard) { create(:standard) }
  let!(:sampling_method) { create(:sampling_method) }
  let!(:data_type) { create(:data_type) }

  let(:location_name) { "Southern California Bight" }
  let(:latitude) { "32.838512" }
  let(:longitude) { "-121.0736997" }

  let!(:admin) { create(:admin) }

  before do
    # these are the examples on the homepage
    create(:species, name: "Carcharhinus acronotus")
    create(:trait, name: "Lmat50")
  end

  it "allows contributor to create new trends" do
    sign_in contributor
    visit new_trend_path

    select2 species.name, css: "#species_selector", search: true
    select2 reference.name, css: "#reference_selector", search: true
    fill_in "Page and Figure Number", with: "10"
    fill_in "Actual page", with: "10"
    fill_in "Actual page", with: "10"
    fill_in "Line used", with: "1"
    fill_in "Figure name", with: "Demo chart"
    fill_in "Pdf page", with: "10"
    attach_file "Figure", "spec/fixtures/img/demo-chart.png"
    select2 standard.name, from: "Unit"
    select2 sampling_method.name, from: "Sampling Method"
    select2 data_type.name, from: "Data Type"
    select2 ocean.name, from: "Ocean"
    fill_in "Depth", with: "100"
    fill_in "Location Name", with: location_name
    fill_in "Latitude", with: latitude
    fill_in "Longitude", with: longitude

    expect(page).not_to have_selector(".trend-chart > canvas")

    fill_in "start year", with: "1999"
    fill_in "end year", with: "2007"

    expect(page).to have_selector(".trend-chart > canvas")

    expect(find("#trend_no_years").value).to eq("9")

    [100, 120, 111, 130, 123, 141, 120, 100, 150].each_with_index do |val, idx|
      fill_in "trend_observations_value_#{1999 + idx}", with: val
    end

    click_button "Create Trend"

    sleep 0.2

    expect(page).to have_content("State: pending review")

    import = contributor.imports.first

    expect(import).to be_pending_review

    visit trends_path

    expect(page).not_to have_content(import.title)

    import.approved_by = admin
    import.approve!

    sleep 0.1

    import.reload

    expect(import).to be_imported

    visit trends_path

    expect(page).to have_content(species.name)
    expect(page).to have_content(reference.name)

    visit trend_path(import.trends.first)

    expect(page).to have_content(species.name)
    expect(page).to have_content(reference.name)
    expect(page).to have_content(ocean.name)
    expect(page).to have_content(location_name)
    expect(page).to have_content(latitude)
    expect(page).to have_content(longitude)
  end

  it "should not permit anonymous users to view the form" do
    visit new_trend_path

    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(current_path).to eq(new_user_session_path)
  end

  it "should not permit non-contributors to view the form" do
    user = create(:user)
    sign_in user

    visit new_trend_path
    expect(current_path).to eq(root_path)
  end
end
