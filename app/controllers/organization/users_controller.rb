# frozen_string_literal: true

# Allows the user to configure users for the organization
class Organization::UsersController < ApplicationController
  before_action :require_login!
  before_action :require_permission!
  before_action :require_user!, only: [:edit, :update, :destroy]
  before_action :set_policy
  before_action { @current_page = :organization_users }

  def index
    @users = current_organization
      .users
      .internal
  end

  def edit
    unless @policy.can_update?
      toast(
        "Sorry, you're not allowed to edit that user",
        status: :forbidden
      )

      return
    end
  end

  def update
    unless @policy.can_update?
      toast(
        "Sorry, you're not allowed to edit that user",
        status: :forbidden
      )

      return
    end

    if @user.update user_params
      respond_to :turbo_stream
    else
      toast(
        "Sorry, we weren't able to update that user",
        status: :internal_server_error
      )
    end
  end

  def new
    unless @policy.can_create?
      toast(
        "Sorry, you're not allowed create users",
        status: :forbidden
      )

      return
    end

    @user = User.new
  end

  def create
    unless @policy.can_create?
      toast(
        "Sorry, you're not allowed create users",
        status: :forbidden
      )

      return
    end

    @user = User.new user_params
    @user.organizations << current_account.organization

    secure_random_pw = SecureRandom.alphanumeric 20
    @user.password = secure_random_pw
    @user.password_confirmation = secure_random_pw

    if @user.save
      UserCreateHandler
        .new(user: @user)
        .run(account: current_account)

      respond_to :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    unless @policy.can_destroy?
      toast(
        "Sorry, you're not allowed to delete that user",
        status: :forbidden
      )

      return
    end

    if @user.destroy
      respond_to :turbo_stream
    else
      toast "Sorry, we weren't able to delete that user"
    end
  end

  private

  #
  # actions
  #

  def require_permission!
    unless current_user.permissions.for_account? current_organization.main_account, :admin
      toast(
        "Sorry, you're not allowed to manage users for #{current_organization.name}",
        status: :forbidden
      )
    end
  end

  def require_user!
    @user = User.find params[:id]
  rescue ActiveRecord::RecordNotFound
    toast(
      "Sorry, we couldn't find that user",
      status: :not_found
    )
  end

  def set_policy
    @policy = UserPolicy.new current_user, current_account, @user
  end

  #
  # params
  #

  def user_params
    params
      .require(:user)
      .permit(
        :first_name,
        :last_name,
        :email
      )
  end
end
