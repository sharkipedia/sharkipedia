# == Schema Information
#
# Table name: data_types
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DataType < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }
end
