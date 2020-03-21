class SearchController < PreAuthController
  KLASSES = {
    "family" => SpeciesFamily,
    "species" => Species,
    "trait" => Trait,
    "ocean" => Ocean,
    "reference" => Reference
  }

  def autocomplete
    key = KLASSES.keys.find { |k| params[:klass] =~ /#{k}/ }
    klass = KLASSES[key]

    @items = if klass && params[:term]
      klass.search_by_name(params[:term])
    else
      []
    end
  end
end
