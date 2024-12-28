# frozen_string_literal: true

# Helper methods for authentication
module AuthenticationHelper
  def require_login!
    unless current_user and current_account
      respond_to do |format|
        format.html { redirect_to login_path }
        format.turbo_stream { head :unauthorized }
        format.json { head :unauthorized }
      end
    end
  end

  def set_current_user!
    log "setting current user"

    user_id = if Rails.env.test?
      cookies[:user_id]
    else
      cookies.signed[:user_id]
    end

    if Rails.env.development? && user_id.blank?
      # Allow submission of an access token via the auth header in development
      log "searching for a token in X-Auth"

      token_value = request.headers["X-Auth"]

      if token_value.present?
        log "X-Auth header is present, looking for access token"

        token = Tokens::AccessToken.find_by value: token_value

        if token.present?
          log "found token #{token.id}"
          user_id = token.user_id
        else
          log "no token found"
        end
      end
    end

    if user_id.present?
      log "found user #{user_id} in cookie"

      session[:user_id] = user_id

      begin
        @current_user = User
          .includes(:accounts)
          .find(session[:user_id])

        Rails.logger.debug "current user.id is: #{@current_user.id}"
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "Your login cookie contains a user that does not exist"
        logout!

        Rails.logger.warn "User's cookie contained an id that doesn't exist"
      end
    end
  end

  def set_current_account!
    log "setting current account"

    if current_user.blank?
      log "cannot set account, user is blank"

      return
    end

    if params[:switch_account]
      log "attempting to switch account"

      account_id = params[:switch_account]

      # check if user can access account
      account = Account.find(account_id)

      if current_user&.account_permission?(account, :any)
        log "switching to account #{account_id}"

        session[:account_id] = account_id
        @current_account = account
        return
      else
        log "user does not have any permission for account #{account_id}"
      end
    end

    # set session var if account hasn't been specified
    unless session[:account_id]
      account = current_user.default_account || current_user.accounts.first
      session[:account_id] = account&.id
    end

    @current_account = Account.find_by id: session[:account_id]

    log "account set to #{@current_account&.id || 'nil'}"
  end

  def set_current_organization!
    @current_organization = @current_account&.organization
  end

  def logout!
    cookies.delete :user_id
    session[:user_id] = nil
    session[:account_id] = nil
    redirect_to login_path
  end

  def persist_current_user(user:)
    if Rails.env.test?
      cookies[:user_id] = user.id
    else
      cookies.signed[:user_id] = user.id
    end

    session[:user_id] = user.id
  end

  def current_user
    @current_user
  end

  def current_user_is(user)
    @current_user = user
  end

  def current_account
    @current_account
  end

  def current_organization
    @current_organization
  end

  def logged_in?
    current_user.present?
  end

  class MissingAccountError < StandardError; end
end
