#
# Base class for all policy objects
#

class ApplicationPolicy
  def initialize(user, account, entity = nil)
    @user = user
    @account = account
    @entity = entity
  end

  def can_view?
    raise NotImplementedError
  end

  def can_update?
    raise NotImplementedError
  end

  def can_manage?
    raise NotImplementedError
  end

  def can_destroy?
    raise NotImplementedError
  end

  protected

  def entity_is_from_same_organization?
    if @entity.respond_to? :organization
      @user.organizations.include? @entity.organization
    elsif @entity.respond_to? :organizations
      (@user.organizations & @entity.organizations).present?
    end
  end
end
