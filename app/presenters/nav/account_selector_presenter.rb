#
# Contains logic for the account selector dropdown in nav
#

class Nav::AccountSelectorPresenter
  def initialize(user:)
    @user = user
  end

  def top_level_accounts
    @user
      .user_account_members
      .joins(:account)
      .joins(:roles)
      .merge(
        Account.where(
          parent_account: @user.default_organization.main_account,
          is_main: false
        )
      )
      .merge(Account.order(is_main: :desc, name: :asc))
      .with_account
      .map(&:account)
  end

  def sub_accounts_for(account:)
    return Account.none if account.blank?

    @user
      .user_account_members
      .joins(:account)
      .joins(:roles)
      .merge(Account.where(parent_account: account, is_main: false))
      .merge(Account.order(is_main: :desc, name: :asc))
      .with_account
      .map(&:account)
  end

  def can_access_main_account?
    @user
      .permissions
      .for_account?(@user.default_organization.main_account, :any)
  end
end
