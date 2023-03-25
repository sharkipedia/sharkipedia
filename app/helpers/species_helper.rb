module SpeciesHelper
  include Pagy::Frontend
  include ProtectedSpeciesHelper

  def international_species_status(species)
    if species.protected_species?
      content_tag(:h5, "Species Regulated by International Treaties", class: "title is-5 mt-3 mb-2") +
        (species.cites_status_none? ? "" : content_tag(:p, "CITES: #{format_protected_status(species.cites_status, species.cites_status_year)} ")) +
        (species.cms_status_none? ? "" : content_tag(:p, "CMS: #{format_protected_status(species.cms_status, species.cms_status_year)}"))
    end
  end
end
