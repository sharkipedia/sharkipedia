class ImportPolicy < ApplicationPolicy
  def show?
    user.editor? || record.user == user
  end

  def new?
    user.contributor?
  end

  def create?
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

  def request_review?
    user.editor? || record.user == user
  end

  def request_changes?
    user.editor?
  end

  def reject?
    user.editor?
  end

  def approve?
    user.editor?
  end

  class Scope < Scope
    def resolve
      if user.admin? || user.editor?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
