#
# Contains view logic related to account billing settings
#

class Accounts::BillingPresenter
  include Rails.application.routes.url_helpers
  
  def initialize(user:, account:, subscription:)
    @account = account
    @subscription = subscription
    @user = user
  end

  def show_manage_billing?
    @subscription.origin_account == @account &&
      @user.permissions.for_account?(@account, :billing)
  end

  def show_parent_account_billing_link?
    @user.permissions.for_account? @subscription.origin_account, :billing
  end

  def show_subaccount_billing_setup_button?
    @user.permissions.for_account? @account, :billing
  end

  def parent_account_billing_link
    origin = @subscription.origin_account

    if origin.main?
      organization_billing_path(switch_account: origin.id)
    else
      account_billing_path(origin, switch_account: origin.id)
    end
  end
end
