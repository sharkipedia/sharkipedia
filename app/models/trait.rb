# == Schema Information
#
# Table name: traits
#
#  id             :bigint           not null, primary key
#  description    :text
#  name           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  trait_class_id :bigint
#
# Indexes
#
#  index_traits_on_trait_class_id  (trait_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (trait_class_id => trait_classes.id)
#
class Trait < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }
  include Describable

  belongs_to :trait_class
  validates :name, presence: true

  has_many :measurements
end
