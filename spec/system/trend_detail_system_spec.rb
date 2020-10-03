require "system_helper"

RSpec.describe "Show an existing trend" do
  before do
    # these are the examples on the homepage
    create(:species, name: "Carcharhinus acronotus")
    create(:trait, name: "Lmat50")
  end

  let(:contributor) { create(:contributor) }
  let!(:import) { create(:imported_trends) }

  # Import#notify_admins needs at least one admin
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
end
