# == Schema Information
#
# Table name: observations
#
#  id             :bigint           not null, primary key
#  access         :string
#  depth          :string
#  hidden         :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  contributor_id :string
#  import_id      :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_observations_on_import_id  (import_id)
#  index_observations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (import_id => imports.id)
#  fk_rails_...  (user_id => users.id)
#
class ObservationSerializer < BaseSerializer
  attributes :depth

  attribute :references do |object|
    object.references.map(&:name)
  end

  has_many :measurements

  has_many :species
end
