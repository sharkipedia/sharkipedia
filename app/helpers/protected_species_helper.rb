module ProtectedSpeciesHelper
  def format_protected_status(status)
    case status
    when "none"
      nil
    when "appendix_1"
      "Appendix I"
    when "appendix_2"
      "Appendix II"
    end
  end

  def tooltip_text(status)
    case status
    when "appendix_1"
      "Appendix I"
    when "appendix_2"
      "Appendix II"
    end
  end
end
