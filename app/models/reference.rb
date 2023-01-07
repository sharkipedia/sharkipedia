# == Schema Information
#
# Table name: references
#
#  id          :bigint           not null, primary key
#  author_year :string
#  data_source :string
#  doi         :string
#  file_public :boolean
#  name        :string           not null
#  reference   :string
#  slug        :string           not null
#  suffix      :string
#  year        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_references_on_name  (name) UNIQUE
#  index_references_on_slug  (slug)
#
class Reference < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :observations
  has_many :trends

  has_one_attached :reference_file

  validates_with DOIValidator

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }
end
