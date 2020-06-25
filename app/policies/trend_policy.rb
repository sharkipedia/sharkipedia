class TrendPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user.contributor?
  end

  def new?
    user.contributor?
  end

  def edit?
    user.admin? || (
      record.import&.user == user && record.import&.state == "changes requested"
    )
  end

  def update?
    user.admin? || (
      record.import&.user == user && record.import&.state == "changes requested"
    )
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      Trend.includes(
        :reference,
        :standard,
        :location,
        :species
      )
        .joins(:import)
        .where('imports.aasm_state': "imported")
    end
  end
end
