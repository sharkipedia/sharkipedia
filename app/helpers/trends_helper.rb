module TrendsHelper
  def paragraph_if_present name, attr
    return if attr.blank? || attr == "NA"

    content_tag(:p, "#{name}: #{attr}")
  end
end
