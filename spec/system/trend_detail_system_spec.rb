require "system_helper"

RSpec.describe "Show an existing trend" do
  before do
    # these are the examples on the homepage
    create(:species, name: "Carcharhinus acronotus")
    create(:trait, name: "Lmat50")
  end

  let(:contributor) { create(:contributor) }
  let!(:import) { create(:imported_trends) }

  let!(:admin) { create(:admin) }

  it "allows users to view trends" do
    sign_in contributor

    visit trends_path

    trend1 = import.trends.first
    trend2 = import.trends.last

    expect(page).to have_content(trend1.species.name)
    expect(page).to have_content(trend1.reference.name)

    expect(page).to have_content(trend2.species.name)
    expect(page).to have_content(trend2.reference.name)

    visit trend_path(trend1)

    expect(page).to have_content(trend1.species.name)
    expect(page).to have_content(trend1.reference.name)
    expect(page).to have_content(trend1.oceans.first.name)
  end

  it "draws the marine regions map with the trend's Longhurst province" do
    trend = import.trends.first
    lon, lat = trend.location.longitude, trend.location.latitude
    create(:longhurst_province, :with_geom, code: "TEST",
      geom_wkt: "MULTIPOLYGON(((#{lon - 1} #{lat - 1}, #{lon + 1} #{lat - 1}, #{lon + 1} #{lat + 1}, #{lon - 1} #{lat + 1}, #{lon - 1} #{lat - 1})))")

    visit trend_path(trend)

    expect(page).to have_css("[data-testid=marine-regions-map] .ol-viewport")
    props = JSON.parse(find("[data-react-class=MarineRegionsMap]", visible: :all)["data-react-props"])
    expect(props["longhurst"]).to eq("TEST")
  end
end
