#
# Used to present accounts in the settings context
#

class Settings::AccountPresenter
  def initialize(account, user:)
    @account = account
    @user = user
  end

  def show_account?
    @user.permissions.for_account?(
      @account,
      :admin
    )
  end

  def show_billing?
    @user.permissions.for_account?(
      @account,
      :billing
    )
  end

  def show_sub_accounts?
    @account.organization.multisite? &&
      @account.can_have_sub_accounts? &&
      @user.permissions.for_account?(
        @account,
        :admin
      )
  end

  def can_create_sub_account?
    @account.organization.multisite?
  end

  def sub_accounts
    if @account.main?
      # child accounts are all other top-level accounts

      @account
        .organization
        .top_level_accounts
        .order(:name)
        .filter { |account| account != @account }
    else
      @account
        .sub_accounts
        .order(:name)
    end
  end

  def notes_text
    if @account.organization.free?
      "#{@account.notes.size} / 50"
    else
      "#{@account.notes.size} / Unlimited"
    end
  end
end