# frozen_string_literal: true

# Allows users to log in and log out
class AuthenticationController < ApplicationController
  include Loggable

  layout "external"

  def login
    redirect_to(current_user&.best_root_path || root_path) if current_user.present?
  end

  def validate
    email = params[:email]

    user = User.internal.find_by(email:)

    if user.present? && user.authenticate(params[:password])
      log "user #{user.id} authenticated"

      # clear the session so any other values (eg current_count) are cleared
      # out for the new user
      session.clear

      # ensure the user is a member of an account
      unless user.default_account?
        flash[:error] = "Sorry, you're not a member of any accounts"
        redirect_to login_path(failed: true)
        return
      end

      persist_current_user(user:)

      redirect_to root_path(redirecting: true)
    else
      log "user authentication failed, incorrect email or password"

      flash[:error] = "Incorrect email or password"
      redirect_to login_path(failed: true)
    end
  end

  def logout
    # delete cookie
    cookies.delete :user_id

    # clear session
    session[:account_id] = nil
    session[:user_id] = nil

    logout_successful = true

    if logout_successful
      path = params[:forwarding_url].presence || login_path

      respond_to do |format|
        format.html do
          flash[:notice] = "You have been succesfully logged out."
          redirect_to path
        end

        format.turbo_stream
      end
    else
      flash[:error] = "Unable to logout, please try again later."
      redirect_to root_path
    end
  end
end
