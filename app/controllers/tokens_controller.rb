# frozen_string_literal: true

# Handles tokens within the app
class TokensController < ApplicationController
  include Loggable

  layout "external"

  skip_before_action :verify_authenticity_token

  before_action :set_token!
  before_action :verify_token

  def show; end

  def update
    if @token.update_from_params params

      @token.update! active: false

      flash[:success] = "Your password has been updated"
      redirect_to @token.user.best_root_path
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  #
  # actions
  #

  def set_token!
    @token = Token.find_by! alt_id: params[:alt_id]
  rescue ActiveRecord::RecordNotFound
    log "could not find token #{params[:alt_id]}"
    render :error, status: :not_found
  end

  def verify_token
    @value = params[:value]

    if @value != @token.value || !@token.active
      log "value provided does not match token value or is not active"
      render :error, status: :not_found
    end
  end
end
