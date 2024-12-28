# frozen_string_literal: true

#
# This object checks for permissions on an object or account given a user
#
class Permissions < ApplicationService
  def initialize(user)
    @user = user
  end

  def for_account?(account, permission)
    return false if account.blank?

    user_account_member = @user.account_membership(account:)

    if user_account_member.present?
      roles = user_account_member.roles

      return true if permission == :external && roles.where(role: [:external, :editor, :scheduling, :billing,
                                                                   :admin, :owner]).exists?

      return true if permission == :any && roles.where(role: [:editor, :scheduling, :billing,
                                                              :admin, :owner]).exists?

      # owners can do everything
      return true if roles.where(role: :owner).exists?

      # admins can do everything except billing
      return true if roles.where(role: :admin).exists? && permission != :billing && permission != :owner

      return true if permission == :billing && roles.where(role: :billing).exists?

      return true if permission == :scheduling && roles.where(role: :scheduling).exists?

      return true if permission == :editor && roles.where(role: :editor).exists?
    end

    false
  end
end
