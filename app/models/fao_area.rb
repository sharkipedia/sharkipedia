# == Schema Information
#
# Table name: fao_areas
#
#  id            :bigint           not null, primary key
#  f_area        :string
#  f_code        :string           not null
#  f_division    :string
#  f_level       :string           not null
#  f_subarea     :string
#  f_subdivision :string
#  f_subunit     :string
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ocean_id      :bigint           not null
#
# Indexes
#
#  index_fao_areas_on_f_code    (f_code)
#  index_fao_areas_on_ocean_id  (ocean_id)
#
# Foreign Keys
#
#  fk_rails_...  (ocean_id => oceans.id)
#
class FaoArea < ApplicationRecord
  belongs_to :ocean
  validates :f_code, presence: true, uniqueness: true
  validates :f_level, presence: true
  validates :name, presence: true

  has_and_belongs_to_many :trends
end
