#
#
#

class AccountPresenter
  def initialize(account)
    @account = account
  end

  def show_sub_account_link?(account, user)
    user.permissions.for_account?(account, :billing) ||
      user.permissions.for_account?(account, :owner) ||
      user.permissions.for_account?(account, :admin)
  end
end
