#
# Allows users to manage users of a specific account
#

class Accounts::MembersController < ApplicationController
  before_action :require_login!
  before_action :require_account!
  before_action :require_permission!
  before_action :require_member!, only: [:edit, :update, :destroy]
  before_action { @current_page = :account_members }

  def index
    @members = @account.members
  end

  def new
    @form = Accounts::Members::NewMemberForm.new
  end

  def create
    @form = Accounts::Members::NewMemberForm.new create_params
    @form.account = @account

    if @form.save
      @member = @form.new_member

      # Make sure the editor has at least the most basic role to start with
      @member.update_roles :editor

      respond_to :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update; end

  def destroy
    if @member.destroy
      respond_to :turbo_stream
    else
      toast(
        "Sorry, we weren't able to remove that user",
        status: :unprocessable_entity
      )
    end
  end

  private

  #
  # actions
  #

  def require_account!
    @account = Account.find_by! alt_id: params[:account_id]

    if @account.blank?
      toast(
        "Sorry, we couldn't find that account",
        status: :not_found
      )
    end
  end

  def require_permission!
    unless current_user.permissions.for_account? @account, :admin
      toast(
        "Sorry, you're not allowed to manage users for #{@account.name}",
        status: :forbidden
      )
    end
  end

  def require_member!
    @member = @account.members.find params[:id]
  rescue ActiveRecord::RecordNotFound
    toast(
      "Sorry, we couldn't find that user in this account",
      status: :not_found
    )
  end

  #
  # params
  #

  def create_params
    params
      .require(:accounts_members_new_member_form)
      .permit(
        :first_name,
        :last_name,
        :email
      )
  end
end
