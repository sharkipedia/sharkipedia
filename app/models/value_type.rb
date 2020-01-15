class ValueType < ApplicationRecord
  include Describable

  validates :name, presence: true, uniqueness: true
end
