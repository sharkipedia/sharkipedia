require "rails_helper"

RSpec.describe "Mass Import" do
  let(:contributor) { create(:contributor) }

  before do
    # these are the examples on the homepage
    create(:species, name: "Carcharhinus acronotus")
    create(:trait, name: "Lmat50")

    # these are required for the validation of the valid traits xlsx sheet
    length = create(:trait_class, name: "Length")
    create(:standard, name: "cm FL", trait_class: length)
    create(:sex_type, name: "Male")

    # Import#notify_admins needs at least one admin
    create(:admin)
  end

  %w[traits trends].each do |kind|
    context kind do
      it "detects invalid excel sheets" do
        sign_in contributor
        visit "/imports/new"

        expect(page).to have_content("Upload XLSX data")
        expect(page).to have_content("Templates")
        expect(page).to have_content("Download Traits Template")

        fill_in "import_title", with: "an invalid #{kind} xlsx"
        attach_file "import_xlsx_file", "spec/fixtures/xlsx/#{kind}_invalid.xlsx"
        click_button "Upload"

        sleep 0.1

        expect(page).to have_content("Type: #{kind}")

        if kind == "traits"
          expect(page).to have_content("State: changes requested")
        else
          expect(page).to have_content("State: pending review")
          # trend mass import doesn't validate at the moment
        end
      end

      it "validates well formed excel sheets" do
        sign_in contributor
        visit "/imports/new"

        expect(page).to have_content("Upload XLSX data")
        expect(page).to have_content("Templates")
        expect(page).to have_content("Download Traits Template")

        fill_in "import_title", with: "a valid #{kind} xlsx"
        attach_file "import_xlsx_file", "spec/fixtures/xlsx/#{kind}_valid.xlsx"
        click_button "Upload"

        sleep 0.1

        expect(page).to have_content("Type: #{kind}")
        expect(page).to have_content("State: pending review")
      end
    end
  end

  it "rejects invalid excel sheets" do
    sign_in contributor
    visit "/imports/new"

    fill_in "import_title", with: "an invalid xlsx"
    attach_file "import_xlsx_file", "spec/fixtures/xlsx/invalid.xlsx"
    click_button "Upload"

    sleep 0.1

    expect(page).to have_content("State: rejected")
  end
end
