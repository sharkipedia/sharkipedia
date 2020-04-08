class ObservationPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  def new?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        Observation.includes(:species)
          .joins(:import)
          .where('imports.aasm_state': 'imported')
      else
        Observation.published.includes(:species)
          .joins(:import)
          .where('imports.aasm_state': 'imported')
      end
    end
  end
end
