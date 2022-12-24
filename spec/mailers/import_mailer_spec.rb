require "rails_helper"

RSpec.describe ImportMailer, type: :mailer do
  describe "#weekly_import_summary_email" do
    subject(:mail) { ImportMailer.with(emails: emails).weekly_import_summary_email }
    let(:emails) { ["hello@example.com"] }
    let!(:import) { create(:traits_import) }

    describe "renders the headers" do
      it { expect(mail.subject).to eq("[sharkipedia] - CW #{Date.current.cweek} import digest") }
      it { expect(mail.to).to eq(emails) }
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello there and welcome to your weekly email digest.")
      expect(mail.body.encoded).to match(import.title)
    end
  end
end
