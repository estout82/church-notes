#
# Responsible for presenting billing widget on account settings
#

class BillingPresenter
  def initialize(account:, subscription:, user:)
    @account = account
    @subscription = subscription
    @user = user
  end

  def show_sub_accounts?
    @subscription.origin_account == @account &&
      @account.can_have_sub_accounts? &&
      @user.permissions.for_account?(@account, :billing)
  end

  def show_price?
    @subscription.origin_account == @account &&
      @user.permissions.for_account?(@account, :billing)
  end

  def show_invoices?
    @subscription.origin_account == @account &&
      !@account.organization.free? &&
      @user.permissions.for_account?(@account, :billing)
  end

  def show_manage_billing?
    @subscription.origin_account == @account &&
      @user.permissions.for_account?(@account, :billing)
  end
end