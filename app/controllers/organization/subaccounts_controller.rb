#
# Allows the user to configure subaccounts for the organization
#
class Organization::SubaccountsController < ApplicationController
  before_action :require_login!
  before_action :set_organization
  before_action :require_permission!
  before_action :require_subaccount!, only: [:destroy, :update]
  before_action :require_policy!
  before_action { @current_page = :organization_subaccounts }

  def index
    @sub_accounts = @organization.top_level_accounts
  end

  def new
    unless @policy.can_create?
      toast(
        "Sorry, you're not allowed to create subaccounts",
        status: :forbidden,
        path: root_path
      )

      return
    end

    @subaccount = Account.new parent_account: current_organization.main_account
  end

  def create
    @account = Account.new create_params
    @account.organization = current_organization
    @account.parent_account = current_organization.main_account

    if @account.save
      member = UserAccountMember.create! user: current_user, account: @account
      UserAccountMemberRole.create! user_account_member: member, role: :owner

      respond_to :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    unless @policy.can_destroy?
      toast(
        "Sorry, you're not allowed to delete that account",
        status: :forbidden,
        path: root_path
      )

      return
    end

    unless @subaccount.can_be_destroyed?
      toast(
        "Sorry, that account cannot be deleted",
        status: :bad_request
      )

      return
    end

    if @subaccount.teardown
      respond_to :turbo_stream
    else
      toast(
        "Sorry, we weren't able to delete that account",
        level: :error
      )
    end
  end

  private

  #
  # actions
  #

  def set_organization
    @organization = current_account.organization
  end

  def require_permission!
    has_permission = current_user.permissions.for_account?(
      @organization.main_account,
      :admin
    )

    unless has_permission
      toast(
        "Sorry, you're now allowed to do that",
        status: :forbidden
      )
    end
  end

  def require_subaccount!
    @subaccount = @organization
      .accounts
      .find_by id: params[:id]

    unless @subaccount.present?
      toast(
        "Sorry, we couldn't find that subaccount",
        status: :not_found
      )
    end
  end

  def require_policy!
    @policy = AccountPolicy.new(
      current_user,
      current_account,
      @subaccount
    )
  end

  #
  # params
  #

  def create_params
    params
      .require(:account)
      .permit(:name, :parent_account_id)
  end

  def update_params
    params
      .require(:account)
      .permit
  end
end
