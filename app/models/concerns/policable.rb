#
# This module allows models to be aware of their policy object.
#

module Policable
  def policy(user:, account:)
    return NilPolicy.new(user) unless policy_constant_exists?
    policy_klass.new(user, account, self)
  end

  def policable?
    policy_constant_exists?
  end

  private

  def policy_name
    self.class.name + "Policy"
  end

  def policy_klass
    policy_name.constantize if policy_constant_exists?
  end

  def policy_constant_exists?
    Object.const_get(policy_name).present?
  rescue NameError
    false
  end
end
