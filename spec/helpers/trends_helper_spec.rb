require "rails_helper"

# Specs in this file have access to a helper object that includes
# the TrendsHelper. For example:
#
describe TrendsHelper, type: :helper do
  describe "paragraph_if_present" do
    context "with value" do
      it "returns the value in a <p> tag" do
        expect(helper.paragraph_if_present("title", "hello")).to eq("<p>title: hello</p>")
      end
    end

    context "with no value" do
      it do
        expect(helper.paragraph_if_present("title", nil)).to be nil
      end
    end

    context "with no value == 'NA'" do
      it do
        expect(helper.paragraph_if_present("title", "NA")).to be nil
      end
    end
  end
end
