class ValidationType < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def name_with_description
    "#{name}#{ description.blank? ? '' : ' - ' }#{description}"
  end
end
