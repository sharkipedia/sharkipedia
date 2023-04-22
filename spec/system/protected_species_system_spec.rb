require "system_helper"

RSpec.describe "List of protected species" do
  let!(:protected_species_cms) { create(:protected_species_cms) }
  let!(:protected_species_cms2) { create(:protected_species_cms, species_order: protected_species_cms.species_order) }
  let!(:protected_species_cites) { create(:protected_species_cites) }
  let!(:unprotected_species) { create(:species, name: "Nope") }

  it "lists protected species" do
    visit protected_species_path

    expect(page).to have_content(protected_species_cms.name)
    expect(page).to have_content(protected_species_cites.name)
  end

  it "does not list non-protected species" do
    visit protected_species_path

    expect(page).not_to have_content(unprotected_species.name)
  end

  it "allows the user to filter by order and family" do
    visit protected_species_path

    click_button "Order"
    click_on protected_species_cms.species_order.name

    expect(page).not_to have_content(protected_species_cites.name)

    click_button "Family"
    click_on protected_species_cms.species_family.name

    expect(page).not_to have_content(protected_species_cms2.name)

    click_button "Family"
    click_on "All"

    expect(page).to have_content(protected_species_cms2.name)

    click_button "Order"
    click_on "All"

    expect(page).to have_content(protected_species_cites.name)
  end
end
