#
# Represents an interaction that cannot be categorized into
# a specific category. Used for user tracking in the main 
# internal part of the app
#

class Interactions::Generic < Interaction
  store_accessor :uri, :params
end
