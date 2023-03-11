# == Schema Information
#
# Table name: oceans
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class OceanSerializer < BaseSerializer
  attributes :id, :name
end
