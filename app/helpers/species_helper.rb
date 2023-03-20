module SpeciesHelper
  include Pagy::Frontend

  def format_status(status)
    case status
    when "appendix_1"
      "Appendix I"
    when "appendix_2"
      "Appendix II"
    when "appendix_3"
      "Appendix III"
    end
  end

  def international_species_status(species)
    if species.cites_status != "none" || species.cms_status != "none"
      content_tag(:h5, "Species Regulated by International Treaties", class: "title is-5 mt-3 mb-2") +
        ((species.cites_status != "none") ? content_tag(:p, "CITES: #{format_status(species.cites_status)}") : "") +
        ((species.cms_status != "none") ? content_tag(:p, "CMS: #{format_status(species.cms_status)}") : "")
    end
  end
end
