class ApplicationController < ActionController::Base
  include AuthenticationHelper
  include Loggable

  before_action :set_current_user!
  before_action :set_current_account!
  before_action :set_current_organization!
  before_action :save_interaction

  rescue_from AuthenticationHelper::MissingAccountError, with: :respond_to_missing_account

  helper_method :current_user, :current_account, :current_organization, :logged_in

  def save_interaction
    Interactions::Generic.create!(
      user: current_user,
      account: current_account,
      data: {
        uri: request.original_url,
        params:
      }
    )
  end

  def require_permission!(permissions)
    permissions = [permissions] unless permissions.instance_of?(Array)

    unless current_user and current_account
      redirect_to login_path

      Rails.logger.debug "The controller action required permissions: #{permissions} but current_user or current_account were nil"
      return
    end

    authorized = false

    permissions.each do |perm|
      authorized ||= current_user.account_permission?(current_account, perm)
    end

    # redirect html requests
    # 403 un-authenticated REST requests
    # 401 authenticated REST requests
    unless authorized
      respond_to do |format|
        format.html do
          flash[:error] = "Sorry, you're not allowed to do that"
          redirect_to login_path # redirect to doot path if we're already logged in

          Rails.logger.debug "The controller action required permissions: #{permissions} but current_user was unauthorized"
        end

        format.json do
          send_forbidden_json_response
        end
      end
    end
  end

  def toast(message, path: root_path, status: :internal_server_error, level: :error)
    respond_to do |format|
      format.html do
        flash[level] = message
        redirect_to root_path
      end
      format.json { render json: { message: }, status: }
      format.turbo_stream { render partial: "application/toast", locals: { message:, level: }, status: }
    end
  end

  def respond_to_missing_account
    #
    # Called when the user that is logged in is not a member of any account
    #

    flash[:error] = "Sorry, it looks like you don't belong to any accounts"
    logout!
  end
end
