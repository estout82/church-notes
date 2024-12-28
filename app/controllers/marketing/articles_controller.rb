# frozen_string_literal: true

# Displays marketing articles
class Marketing::ArticlesController < ApplicationController
  layout "marketing"

  def show
    @slug = params[:slug]&.to_sym
  end
end
