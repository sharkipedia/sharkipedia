# == Schema Information
#
# Table name: references
#
#  id              :bigint           not null, primary key
#  author_year     :string
#  data_source     :string
#  date            :date
#  doi             :string
#  epub_date       :date
#  errata          :string
#  file_public     :boolean
#  issue           :string
#  journal         :string
#  name            :string           not null
#  pages           :string
#  part_supplement :string
#  reference       :string
#  slug            :string           not null
#  start_page      :integer
#  suffix          :string
#  title           :string
#  volume          :string
#  year            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_references_on_name  (name) UNIQUE
#  index_references_on_slug  (slug)
#
class Reference < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  serialize :author, Array

  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :observations
  has_and_belongs_to_many :authors
  has_many :trends

  has_one_attached :reference_file

  validates_with DOIValidator

  accepts_nested_attributes_for :authors, reject_if: :all_blank, allow_destroy: true

  before_validation :find_authors

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }

  private

  def find_authors
    self.authors = authors.map do |author|
      Author.where(name: author.name).first_or_initialize
    end
  end
end
