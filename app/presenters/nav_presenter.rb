#
# Contains view logic for the nav
#

class NavPresenter
  def initialize(account, permissions)
    @account = account
    @permissions = permissions
  end

  def show_subaccount_selector?
    @account.organization.multisite?
  end

  def show_notes_tab?
    @permissions.for_account? @account, :editor
  end

  def show_schedule_tab?
    @permissions.for_account? @account, :scheduling
  end

  def show_account_settings?
    @permissions.for_account?(@account, :admin)
  end

  def show_sub_account_settings_tab?
    !@account.main? && @account.organization.multisite? && @permissions.for_account?(@account, :admin)
  end

  def show_account_billing?
    !@account.main? && @permissions.for_account?(@account, :billing)
  end

  def show_account_subaccounts?
    !@account.main? && @account.organization.multisite? && @permissions.for_account?(@account, :admin)
  end

  def show_account_users?
    ((!@account.main? && @account.organization.multisite?) || @account.organization.base?) && @permissions.for_account?(@account, :admin)
  end

  def show_organization_settings?
      @permissions.for_account?(@account.organization.main_account, :admin)
  end

  def show_organization_settings_tab?
    @permissions.for_account?(@account.organization.main_account, :admin)
  end

  def show_organization_integrations_tab?
    @account.organization.multisite? && @permissions.for_account?(@account.organization.main_account, :admin)
  end

  def show_organization_billing?
    @permissions.for_account?(@account.organization.main_account, :billing)
  end

  def show_organization_subaccounts?
    @account.organization.multisite? && @permissions.for_account?(@account.organization.main_account, :admin)
  end

  def show_organization_users?
    @account.organization.multisite? && @permissions.for_account?(@account.organization.main_account, :admin)
  end

  def show_integrations?
    @account.organization.multisite? && @permissions.for_account?(@account.organization.main_account, :admin)
  end
end
