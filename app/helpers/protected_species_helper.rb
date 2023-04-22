module ProtectedSpeciesHelper
  def format_protected_status(status, year = nil)
    case status
    when "none"
      nil
    when "appendix_1"
      # Temp fix - right now now all of our Protected Species have populated year colums
      year ? "Appendix I (#{year})" : "Appendix I"
    when "appendix_2"
      year ? "Appendix II (#{year})" : "Appendix II"
    when "appendix_3"
      year ? "Appendix III (#{year})" : "Appendix III"
    end
  end

  def tooltip_text(status, type)
    case [status, type]
    in ["appendix_1", :cites_status]
      <<~TOOLTIP
        Appendix I lists species that are the most endangered among CITES-listed animals and plants. They are threatened
        with extinction and CITES prohibits international trade in specimens of these species except when the purpose of
        the import is not commercial, for instance for scientific research. In these exceptional cases, trade may take
        place provided it is authorized by the granting of both an import permit and an export permit (or re-export
        certificate).
      TOOLTIP
    in ["appendix_2", :cites_status]
      <<~TOOLTIP
        Appendix II lists species that are not necessarily now threatened with extinction but that may become so unless 
        trade is closely controlled. It also includes so-called "look-alike species", i.e. species whose specimens in 
        trade look like those of species listed for conservation reasons. International trade in specimens of 
        Appendix-II species may be authorized by the granting of an export permit or re-export certificate. Permits or
        certificates should only be granted if the relevant authorities are satisfied that certain conditions are met.
        For sharks and rays, export permits are only granted following a Non-detriment Finding (NDF) by the fishing
        entity.
      TOOLTIP
    in ["appendix_3", :cites_status]
      <<~TOOLTIP
        Appendix III is a list of species included at the request of a Party that already regulates trade in the species
        and that needs the cooperation of other countries to prevent unsustainable or illegal exploitation.
        International trade in specimens of species listed in this Appendix is allowed only on presentation of the
        appropriate permits or certificates.
      TOOLTIP
    in ["appendix_1", :cms_status]
      <<~TOOLTIP
        Appendix I comprises migratory species that have been assessed as being in danger of extinction throughout all
        or a significant portion of their range. The Conference of the Parties has further interpreted the term
        “endangered” as meaning “facing a very high risk of extinction in the wild in the near future”. Parties that are
        a Range State to a migratory species listed in Appendix I shall endeavour to strictly protect them by:
        prohibiting the taking of such species, with very restricted scope for exceptions; conserving and where
        appropriate restoring their habitats; preventing, removing or mitigating obstacles to their migration and
        controlling other factors that might endanger them.
      TOOLTIP
    in ["appendix_2", :cms_status]
      <<~TOOLTIP
        Appendix II covers migratory species that have an unfavourable conservation status and that require
        international agreements for their conservation and management, as well as those that have a conservation status
        which would significantly benefit from the international cooperation that could be achieved by an international
        agreement. The Convention encourages the Range States to species listed on Appendix II to conclude global or
        regional Agreements for the conservation and management of individual species or groups of related species.
      TOOLTIP
    else
      ""
    end
  end

  def format_protected_species_path(order: nil, family: nil)
    if order && family
      protected_species_path(filter: {order: order, family: family})
    elsif order
      protected_species_path(filter: {order: order})
    elsif family
      protected_species_path(filter: {family: family})
    else
      protected_species_path
    end
  end
end
