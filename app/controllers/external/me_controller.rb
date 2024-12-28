# frozen_string_literal: true

# Allows external users to update themselves
class External::MeController < External::BaseController
  before_action :set_user

  def show; end

  def edit
    @field = params.fetch(:field, nil)&.to_sym
  end

  def update; end

  private

  def set_user
    @user = current_user
  end
end
