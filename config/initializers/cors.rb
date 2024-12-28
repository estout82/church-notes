#
# Configures CORS support
#
# Note: We only want CORS in development to allow story book to make requests to the app
# when working on the note editor Reach component JS package.
#

if Rails.env.development?
  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins "*"

      resource "*",
        headers: :any,
        methods: [:get, :post, :patch, :put, :delete, :options, :head]
    end
  end
end
