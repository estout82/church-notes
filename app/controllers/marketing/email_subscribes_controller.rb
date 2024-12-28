# frozen_string_literal: true

# Allows people to subscribe to the email list
class Marketing::EmailSubscribesController < ApplicationController
  before_action :set_context

  def create
    Marketing::EmailSubscribeJob.perform_later(email: params[:email], context: @context.to_s)

    if @context.default?
      respond_to :turbo_stream
    else
      flash[:success] =
        "Thanks, we'll set up your trial ASAP. Check your email soon. Reach out to hello@notespro.church if you have any questions."

      redirect_to login_url, allow_other_host: true
    end
  end

  private

  def set_context
    @context = params.fetch(:context, "default").inquiry
  end
end
