# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Author < ApplicationRecord
  has_and_belongs_to_many :references

  validates :name, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }
end
