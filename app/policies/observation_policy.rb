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
        Observation.all
      else
        Observation.published
      end
    end
  end
end
