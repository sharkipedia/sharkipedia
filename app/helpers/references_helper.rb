module ReferencesHelper
  def display_authors(authors)
    return "" if authors.nil?

    if authors.is_a?(String)
      YAML.load(authors).join(", ")
    else
      authors.join(", ")
    end
  end
end
