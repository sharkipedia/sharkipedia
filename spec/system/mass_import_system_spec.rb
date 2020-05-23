require "rails_helper"

RSpec.describe "Mass Import" do
  let(:contributor) { create(:contributor) }
  let(:admin) { create(:admin) }

  before do
    # these are the examples on the homepage
    create(:species, name: "Carcharhinus acronotus")
    create(:trait, name: "Lmat50")

    # these are required for the validation of the valid traits xlsx sheet
    length = create(:trait_class, name: "Length")
    create(:standard, name: "cm FL", trait_class: length)
    create(:sex_type, name: "Male")

    # Import#notify_admins needs at least one admin
    admin
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

      it "allows admins to reject" do
        import = create("#{kind}_import")

        sign_in admin
        visit import_path(import)

        # click_link "Reject"
        find("#reject-btn").click()

        fill_in "reason", with: "just say no"
        click_on "Reject"

        sleep 0.1

        import.reload
        expect(import).to be_rejected
      end

      it "allows admins to request changes" do
        import = create("#{kind}_import")

        sign_in admin
        visit import_path(import)

        # click_link "Request Changes"
        find("#request-changes-btn").click()

        fill_in "reason", with: "please try again"
        click_on "Request changes"

        sleep 0.1

        import.reload
        expect(import).to be_changes_requested
      end

      it "allows admins to approve" do
        import = create("#{kind}_import")

        sign_in admin
        visit import_path(import)

        # click_link "Approve"
        find("#approve-btn").click()

        click_on "Approve and Import"

        if kind == "trends"
          pending "Trend mass imports are defunct at the moment"
        end

        sleep 0.1

        import.reload
        expect(import).to be_imported
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
