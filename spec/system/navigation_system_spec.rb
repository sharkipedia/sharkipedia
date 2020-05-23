require "rails_helper"

RSpec.describe "navbar" do
  before do
    # these are the examples on the homepage
    create(:species, name: "Carcharhinus acronotus")
    create(:trait, name: "Lmat50")
  end

  context "anonymous user" do
    before do
      visit "/"
    end

    it { expect(page).not_to have_content("Upload Data") }
    it { expect(page).not_to have_content("Review") }
    it { expect(page).not_to have_content("Admin Dashboard") }
  end

  context "users" do
    before do
      user = create(:user)
      sign_in user
      visit "/"
    end

    it { expect(page).not_to have_content("Upload Data") }
    it { expect(page).not_to have_content("Review") }
    it { expect(page).not_to have_content("Admin Dashboard") }
  end

  context "contributors" do
    before do
      contributor = create(:contributor)
      sign_in contributor
      visit "/"
    end

    it { expect(page).to have_content("Upload Data") }
    it { expect(page).not_to have_content("Review") }
    it { expect(page).not_to have_content("Admin Dashboard") }
  end

  context "editors" do
    before do
      editor = create(:editor)
      sign_in editor
      visit "/"
    end

    it { expect(page).to have_content("Upload Data") }
    it { expect(page).not_to have_content("Review") }
    it { expect(page).not_to have_content("Admin Dashboard") }
  end

  context "admins" do
    before do
      admin = create(:admin)
      sign_in admin
      visit "/"
    end

    it { expect(page).to have_content("Upload Data") }
    it { expect(page).to have_content("Review") }
    it { expect(page).to have_content("Admin Dashboard") }
  end
end
