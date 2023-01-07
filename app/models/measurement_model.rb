# == Schema Information
#
# Table name: measurement_models
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
#  index_measurement_models_on_trait_class_id  (trait_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (trait_class_id => trait_classes.id)
#
class MeasurementModel < ApplicationRecord
  include Describable

  belongs_to :trait_class
  validates :name, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }
end
