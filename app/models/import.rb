class Import < ApplicationRecord
  TYPES = %w( traits trends )
  belongs_to :user
  belongs_to :approved_by, class_name: 'User', optional: true

  validates :title, presence: true
  validates_inclusion_of :import_type, in: TYPES

  has_one_attached :xlsx_file

  def uploaded_by
    user.email
  end

  def self.import_types
    TYPES
  end
end
