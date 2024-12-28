#
# Constants that are related to the entire application
#

class Constants::Application
  DEFAULT_HOST = if Rails.env.production?
    "app.notespro.church"
  else
    "localhost:5501"
  end
end
