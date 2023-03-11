# == Schema Information
#
# Table name: standards
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
#  index_standards_on_trait_class_id  (trait_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (trait_class_id => trait_classes.id)
#
class Standard < ApplicationRecord
  include Describable

  belongs_to :trait_class, optional: true
  validates :name, presence: true

  has_many :measurements
  has_many :trends

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }
end
