#
# Controls access to schedule objects
#

class SchedulePolicy < ApplicationPolicy
  def can_index?
    has_permission?
  end

  def can_view?
    has_permission? && @entity.account == @account
  end

  def can_update?
    #
    # users can only edit notes from the account they're currently on and
    # have scheduling permission for that account
    #

    has_permission? && @entity.account == @account
  end

  def can_manage?
    can_update?
  end

  def can_create?
    has_permission?
  end
  
  def can_destroy?
    can_update?
  end

  private
  
  def has_permission?
    @user.permissions.for_account? @account, :scheduling
  end
end
