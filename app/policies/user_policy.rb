#
# Controls access to users
#
# TODO we should probably not allow free plan orgs to create users
#

class UserPolicy < ApplicationPolicy
  def can_view?
    admin? && entity_is_from_same_organization?
  end

  def can_update?
    admin? && entity_is_from_same_organization?
  end

  def can_manage?
    admin? && entity_is_from_same_organization?
  end

  def can_destroy?
    admin? && entity_is_from_same_organization?
  end

  def can_create?
    admin?
  end

  private

  def admin?
    @user.permissions.for_account? @account, :admin
  end
end
