module ProtectedSpeciesHelper
  def format_protected_status(status, year)
    case status
    when "none"
      nil
    when "appendix_1"
      # Temp fix - right now now all of our Protected Species have populated year colums
      year ? "Appendix I (#{year})" : "Appendix I"
    when "appendix_2"
      year ? "Appendix II (#{year})" : "Appendix II"
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
