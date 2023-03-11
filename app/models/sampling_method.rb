# == Schema Information
#
# Table name: sampling_methods
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SamplingMethod < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }
end
