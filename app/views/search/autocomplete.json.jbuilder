json.array! @items do |item|
  json.id item.id
  json.name item.name
  json.description item.try(:description) || item.try(:reference)
end
