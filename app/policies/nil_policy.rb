#
# A policy that always returns false (Nil object pattern)
#

class NilPolicy < ApplicationPolicy
  def can_view?
    false
  end

  def can_update?
    false
  end

  def can_manage?
    false
  end

  def can_update?
    false
  end
end
