# == Schema Information
#
# Table name: species
#
#  id                    :bigint           not null, primary key
#  authorship            :string
#  cites_status          :integer          default("none")
#  cites_status_year     :string
#  cms_status            :integer          default("none")
#  cms_status_year       :string
#  edge_scientific_name  :string
#  iucn_code             :string
#  name                  :string           not null
#  scientific_name       :string
#  slug                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  species_data_type_id  :bigint
#  species_family_id     :bigint
#  species_order_id      :bigint
#  species_subclass_id   :bigint
#  species_superorder_id :bigint
#
# Indexes
#
#  index_species_on_slug                   (slug)
#  index_species_on_species_data_type_id   (species_data_type_id)
#  index_species_on_species_family_id      (species_family_id)
#  index_species_on_species_order_id       (species_order_id)
#  index_species_on_species_subclass_id    (species_subclass_id)
#  index_species_on_species_superorder_id  (species_superorder_id)
#
# Foreign Keys
#
#  fk_rails_...  (species_data_type_id => species_data_types.id)
#  fk_rails_...  (species_family_id => species_families.id)
#  fk_rails_...  (species_order_id => species_orders.id)
#  fk_rails_...  (species_subclass_id => species_subclasses.id)
#
class Species < ApplicationRecord
  enum cms_status: [:none, :appendix_1, :appendix_2], _prefix: true
  enum cites_status: [:none, :appendix_1, :appendix_2, :appendix_3], _prefix: true

  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name],
    using: {
      tsearch: {
        prefix: true
      }
    }

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
  validates :cites_status_year, numericality: {in: 1900..9999}, if: :cites_status_year
  validates :cms_status_year, numericality: {in: 1900..9999}, if: :cms_status_year

  validate :validate_cms_status_if_year
  validate :validate_cites_status_if_year
  validates :cites_status_year, presence: true, unless: :cites_status_none?
  validates :cms_status_year, presence: true, unless: :cms_status_none?

  before_validation :reject_empty_years

  belongs_to :species_superorder
  belongs_to :species_data_type
  belongs_to :species_subclass
  belongs_to :species_order
  belongs_to :species_family

  has_many :measurements
  has_many :observations, through: :measurements
  has_many :trends

  has_and_belongs_to_many :species_groups

  def group_trends
    Trend.where(species_group: species_groups)
  end

  def protected_species?
    !cms_status_none? || !cites_status_none?
  end

  private

  def reject_empty_years
    if cites_status_year == ""
      self.cites_status_year = nil
    end

    if cms_status_year == ""
      self.cms_status_year = nil
    end
  end

  def validate_cms_status_if_year
    errors.add(:cms_status, "can't be :none if a year is set") if cms_status_year && cms_status_none?
  end

  def validate_cites_status_if_year
    errors.add(:cites_status, "can't be :none if a year is set") if cites_status_year && cites_status_none?
  end
end
