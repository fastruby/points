class VersionJumpPolicy < ApplicationPolicy
  def update?
    true
  end

  def create?
    true
  end
end
