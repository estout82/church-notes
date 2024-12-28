# frozen_string_literal: true

# Allows external users to sign up while viewing notes, browsing library, etc
class External::SignUpsController < External::BaseController
  before_action :set_organization!
  before_action -> { current_external_organization_is @organization }

  def new
    @sign_up = External::SignUp.new(interest_url: params[:interest_url])
  end

  def create
    @sign_up = External::SignUp.from_params create_params, organization: @organization
    @user = @sign_up.provision

    if @user
      persist_current_user user: @user

      flash[:success] = @sign_up.success_message
      redirect_to @sign_up.interest_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_organization!
    @organization = Organization.find_by! alt_id: params[:external_organization_id]
  end

  def create_params
    params
      .require(:external_sign_up)
      .permit(:first_name, :last_name, :email, :password, :password_confirmation, :interest_url)
  end
end
