class UserAccountMember < ApplicationRecord
  belongs_to :user
  belongs_to :account

  has_many :roles, class_name: "UserAccountMemberRole", dependent: :destroy

  scope :with_account, -> { includes(:account) }

  def role_names
    roles.pluck(:role).map(&:to_sym)
  end

  def update_roles(names)
    names = [names] unless names.is_a? Array

    roles.destroy_all

    names = names.map(&:to_sym)

    if names.present?
      names.each do |name|
        if [:editor, :billing, :admin, :owner, :scheduling].include? name
          roles << UserAccountMemberRole.new(user_account_member: self, role: name)
        end
      end
    end

    save
  end
end
