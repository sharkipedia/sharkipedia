require "rails_helper"

RSpec.describe ProtectedSpeciesHelper, type: :helper do
  describe "#format_protected_status" do
    it "retuns nil when given status of none" do
      expect(helper.format_protected_status("none")).to eq(nil)
    end
    it "retuns Appendix I when given status of appendix_1" do
      expect(helper.format_protected_status("appendix_1")).to eq("Appendix I")
    end
    it "retuns Appendix II when given status of appendix_2" do
      expect(helper.format_protected_status("appendix_2")).to eq("Appendix II")
    end
  end

  describe "#tooltip_text" do
    it "returns Appendix I when given a status of appendix_1" do
      expect(helper.tooltip_text("appendix_1")).to eq("Appendix I")
    end
    it "returns Appendix II when given a status of appendix_2" do
      expect(helper.tooltip_text("appendix_2")).to eq("Appendix II")
    end
  end
end