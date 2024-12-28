#
# Controls access to account objects
#

class AccountPolicy < ApplicationPolicy
  def can_view?
    (billing? || admin?) && entity_is_from_same_organization?
  end

  def can_update?
    admin? && entity_is_from_same_organization?
  end

  def can_manage?
    admin? && entity_is_from_same_organization?
  end

  def can_destroy?
    admin? && !@entity.main? && entity_is_from_same_organization?
  end

  def can_create?
    @account.organization.multisite?
  end

  private

  def billing?
    @user.permissions.for_account? @entity, :billing
  end

  def admin?
    @user.permissions.for_account? @entity, :admin
  end
end
