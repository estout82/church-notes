# frozen_string_literal: true

# The marketing site
class MarketingController < ApplicationController
  layout "marketing"

  def index
    @sign_up = SignUp.new
  end
end
