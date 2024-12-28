#
# Controls access to user account members
#

class UserAccountMemberPolicy < ApplicationPolicy
  def can_view?
    admin? || main_account_admin?
  end

  def can_update?
    admin? || main_account_admin?
  end

  def can_manage?
    admin? || main_account_admin?
  end

  def can_destroy?
    admin? || main_account_admin?
  end

  def can_create?
    admin? || main_account_admin?
  end

  private

  def admin?
    @user.permissions.for_account? @account, :admin
  end

  def main_account_admin?
    @user.permissions.for_account? @account.main_account, :admin
  end
end
