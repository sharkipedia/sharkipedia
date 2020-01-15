class MeasurementMethod < ApplicationRecord
  belongs_to :trait_class
  validates :name, presence: true

  def name_with_description
    "#{name}#{ description.blank? ? '' : ' - ' }#{description}"
  end
end
