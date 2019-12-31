module ApplicationHelper
  def user_is_admin?
    current_user.try(:admin?)
  end

  def link_to_doi doi
    link_to doi, "https://www.doi.org/#{doi}", target: "_blank" if doi
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) { |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    }
    link_to(name, "#", class: "add_fields", data: {id: id, fields: fields.delete("\n")})
  end
end
