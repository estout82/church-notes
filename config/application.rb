# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChurchNotes
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.session_store :cookie_store,
      key: "_yjvENJdT3UxA",
      domain: :all,
      tld_length: 2

    config.middleware.use Rack::Deflater
  end
end
