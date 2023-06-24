require "system_helper"

RSpec.describe "New Reference Form" do
  let(:contributor) { create(:contributor) }
  let(:known_author) { create(:author, name: "Known Author") }

  before do
    # these are for the homepage and are required for the redirection of not logged in users
    create(:species, name: "Carcharhinus acronotus")
    create(:species, name: "Prionace glauca")
    create(:trait, name: "Lmat50")
    create(:ocean, name: "Atlantic")
  end

  it "redirects to the main page if the user is not logged in" do
    visit "/references/new"
    expect(page).to have_content("If you wish to upload trait data, please make an account.")
  end

  it "creates a reference with no author" do
    sign_in contributor
    visit "/references/new"

    expect(page).to have_content("New Reference")

    fill_in "reference_name", with: "A new reference"
    click_button "Create Reference"

    expect(page).to have_content("A new reference")
  end

  it "creates a reference with a known author, with a dropdown that contains the known author name" do
    sign_in contributor
    visit "/references/new"

    expect(page).to have_content("New Reference")

    fill_in "reference_name", with: "A new reference"

    fill_in "reference_authors_attributes_0_name", with: known_author.name[0..4]
    sleep 0.1

    expect(page).to have_selector(".dropdown-item", text: known_author.name)
    find(".dropdown-item").click

    click_button "Create Reference"

    expect(page).to have_content("A new reference")
    expect(page).to have_content(known_author.name)
  end

  it "creates a reference with a new author, and no dropdown suggestion for the author name" do
    sign_in contributor
    visit "/references/new"

    expect(page).to have_content("New Reference")

    fill_in "reference_name", with: "A new reference"

    fill_in "reference_authors_attributes_0_name", with: "Brand New Author"
    sleep 0.1

    expect(page).not_to have_selector(".dropdown-item", text: "Brand New Author")

    expect {
      click_button "Create Reference"
    }.to change(Author, :count).by(1)

    expect(page).to have_content("A new reference")
    expect(page).to have_content("Brand New Author")
  end

  it "creates a reference with two new authors and adds them to Authors table" do
    sign_in contributor
    visit "/references/new"

    expect(page).to have_content("New Reference")

    fill_in "reference_name", with: "A new reference"

    fill_in "reference_authors_attributes_0_name", with: "Brand New Author"

    find(".vanilla-nested-add").click
    sleep 0.1
    expect(page).to have_selector(".added-by-vanilla-nested", count: 1)
    second_author_input = find(".added-by-vanilla-nested input")

    second_author_input.fill_in with: "Second Author"

    expect {
      click_button "Create Reference"
    }.to change(Author, :count).by(2)

    expect(page).to have_content("A new reference")
    expect(page).to have_content("Brand New Author")
    expect(page).to have_content("Second Author")
  end
end
