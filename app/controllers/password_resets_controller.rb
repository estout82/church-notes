# frozen_string_literal: true

# Allows users to reset their password
class PasswordResetsController < ApplicationController
  include Loggable

  layout "external"

  def new
    @password_reset = PasswordReset.new
    @external = params[:external].present?
  end

  def create
    @password_reset = PasswordReset.new password_reset_params

    if @password_reset.valid?

      if @password_reset.save

        respond_to do |format|
          format.html do
            flash[:success] = "Please check your inbox for a link to finish resetting your password."
            redirect_to login_path
          end

          format.turbo_stream
        end

      else
        log "failed to save password reset token"
        render :new, status: :internal_server_error
      end

    else
      log "password reset form is not valid"
      render :new, status: :unprocessable_entity
    end
  end

  private

  #
  # params
  #

  def password_reset_params
    params
      .require(:password_reset)
      .permit(:email)
  end
end
