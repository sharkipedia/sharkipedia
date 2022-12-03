require "system_helper"

RSpec.describe "List of protected species" do
  let!(:protected_species_cms) { create(:protected_species_cms)}
  let!(:protected_species_cites) { create(:protected_species_cites)}
  let!(:unprotected_species) { create(:species, name: "Nope" )}

  it "lists protected species" do
    visit protected_species_path

    expect(page).to have_content(protected_species_cms.name)
    expect(page).to have_content(protected_species_cites.name)
  end

  it "does not list non-protected species" do
    visit protected_species_path

    expect(page).not_to have_content(unprotected_species.name)
  end
end