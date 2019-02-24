class Standard < ApplicationRecord
  belongs_to :trait_class, optional: true
  validates :name, presence: true
end
