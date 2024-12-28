#
# Allows adding users directly to an account
#

class Settings::Account::UserAdditionsController < ApplicationController
  include Loggable

  before_action :require_login!
  before_action :set_account!
  before_action :require_admin!

  def new
    @user = User.new
  end

  def create
    organization = @account.organization

    @user = User.new create_params
    @user.organizations << organization

    secure_random_pw = SecureRandom.alphanumeric 20
    @user.password = secure_random_pw
    @user.password_confirmation = secure_random_pw

    if @user.valid?

      existing_user = organization.users.find_by email: @user.email

      if existing_user.present?
        # just add existing user to account
        UserAccountMember.create!(
          user: existing_user,
          account: @account
        )

        respond_to :turbo_stream

      elsif @user.save
        # create a whole new user and add to this account

        UserCreateHandler.new(user: @user).run

        UserAccountMember.create!(
          user: @user,
          account: @account
        )

        respond_to :turbo_stream

      else
        # unable to save user...
        log "unable to save user #{@user.inspect}"

        toast(
          "Sorry, we weren't able to save that user",
          status: :internal_server_error
        )

      end

    else
      log "user is invalid #{@user.inspect}"
      log "errors: #{@user.errors.full_messages}"

      render :new
    end
  end

  private

  #
  # actions
  #

  def set_account!
    @account = current_account
  end

  def require_admin!
    unless current_user.permissions.for_account?(@account, :admin)
      toast(
        "Sorry, you're not allowed to add users to #{@account.name}",
        status: :unauthorized,
        level: :error
      )
    end
  end

  #
  # params
  #

  def create_params
    params
      .require(:user)
      .permit(:first_name, :last_name, :email)
  end
end
