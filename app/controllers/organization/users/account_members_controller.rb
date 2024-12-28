#
# Controls user account members
#
# TODO check policy on account when creating
#

class Organization::Users::AccountMembersController < ApplicationController
  before_action :require_login!
  before_action :require_member!, only: [:edit, :update, :destroy]
  before_action :set_policy

  def edit
    unless @policy.can_update?
      toast(
        "Sorry, you're not able to edit that account member",
        status: :forbidden
      )
    end
  end

  def update
    unless @policy.can_update?
      toast(
        "Sorry, you're not able to edit that account member",
        status: :forbidden
      )
    end

    @names = params[:user_account_member][:role_names]

    if @member.update_roles @names
    else
    end
  end

  def new
    unless @policy.can_create?
      toast(
        "Sorry, you're not able to create account members",
        status: :forbidden
      )
    end
    
    @member = UserAccountMember.new
    @member.user_id = params[:user_id] if params[:user_id].present?
  end

  def create
    unless @policy.can_create?
      toast(
        "Sorry, you're not able to create account members",
        status: :forbidden
      )
    end

    @member = UserAccountMember.new user_account_member_params

    if @member.save
      @member.update_roles :editor
    else
    end
  end

  def destroy
    unless @policy.can_destroy?
      toast(
        "Sorry, you're delete that account member",
        status: :forbidden
      )
    end

    if @member.destroy
      @remove_user_row = params.fetch(:remove_user_row, false)

      respond_to :turbo_stream
    else
      toast(
        "Sorry, we weren't able to remove #{@member.user.first_name} from #{@member.account.name}",
        status: :internal_server_error
      )
    end
  end

  private

  #
  # actions
  #

  def require_member!
    @member = UserAccountMember.find params[:id]
  rescue ActiveRecord::RecordNotFound
    toast(
      "Sorry, we're not able to find that account member",
      status: :not_found
    )
  end

  def set_policy
    @policy = UserAccountMemberPolicy.new current_user, current_account, @member
  end

  #
  # params
  #

  def user_account_member_params
    params
      .require(:user_account_member)
      .permit(:user_id, :account_id)
  end
end
