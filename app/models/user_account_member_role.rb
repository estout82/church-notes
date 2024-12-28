class UserAccountMemberRole < ApplicationRecord
  belongs_to :user_account_member
  has_one :user, through: :user_account_member

  enum role: [:no_role, :external, :editor, :scheduling, :billing, :admin, :owner]
end
