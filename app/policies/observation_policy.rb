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
      if user && user.admin?
        Observation.includes(:species).all
      else
        Observation.published.includes(:species)
      end
    end
  end
end
