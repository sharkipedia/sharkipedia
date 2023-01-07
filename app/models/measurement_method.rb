# == Schema Information
#
# Table name: measurement_methods
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
#  index_measurement_methods_on_trait_class_id  (trait_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (trait_class_id => trait_classes.id)
#
class MeasurementMethod < ApplicationRecord
  include Describable

  belongs_to :trait_class
  validates :name, presence: true
end
