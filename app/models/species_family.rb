# == Schema Information
#
# Table name: species_families
#
#  id                    :bigint           not null, primary key
#  name                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  species_order_id      :bigint
#  species_subclass_id   :bigint
#  species_superorder_id :bigint
#
# Indexes
#
#  index_species_families_on_species_order_id       (species_order_id)
#  index_species_families_on_species_subclass_id    (species_subclass_id)
#  index_species_families_on_species_superorder_id  (species_superorder_id)
#
# Foreign Keys
#
#  fk_rails_...  (species_order_id => species_orders.id)
#  fk_rails_...  (species_subclass_id => species_subclasses.id)
#  fk_rails_...  (species_superorder_id => species_superorders.id)
#
class SpeciesFamily < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }

  validates :name, presence: true, uniqueness: true

  belongs_to :species_subclass
  belongs_to :species_superorder
  belongs_to :species_order
end
