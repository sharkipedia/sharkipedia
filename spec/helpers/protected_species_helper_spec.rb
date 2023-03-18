require "rails_helper"

RSpec.describe ProtectedSpeciesHelper, type: :helper do
  describe "#format_protected_status" do
    it "retuns nil when given status of none" do
      expect(helper.format_protected_status("none")).to eq(nil)
    end
    it "retuns Appendix I when given status of appendix_1" do
      expect(helper.format_protected_status("appendix_1", 1999)).to eq("Appendix I (1999)")
    end
    it "retuns Appendix II when given status of appendix_2" do
      expect(helper.format_protected_status("appendix_2", 2012)).to eq("Appendix II (2012)")
    end
    it "retuns Appendix III when given status of appendix_3" do
      expect(helper.format_protected_status("appendix_3", 2002)).to eq("Appendix III (2002)")
    end
  end

  describe "#tooltip_text" do
    it "returns Appendix I when given a status of appendix_1" do
      expect(helper.tooltip_text("appendix_1", :cites_status)).to match(/Appendix I /)
    end
    it "returns Appendix II when given a status of appendix_2" do
      expect(helper.tooltip_text("appendix_2", :cms_status)).to match(/Appendix II /)
    end
    it "returns Appendix III when given a status of appendix_3" do
      expect(helper.tooltip_text("appendix_3", :cites_status)).to match(/Appendix III /)
    end
  end
end
