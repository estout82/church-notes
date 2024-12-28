#
# Represents a password rest token
#

class Tokens::PasswordReset < Token
  include Loggable

  attr_accessor :password, :password_confirmation

  validates :password,
    confirmation: true,
    presence: true,
    on: :update

  def update_from_params(params)
    self.password = params[:password]
    self.password_confirmation = params[:password]

    if valid?
      if user.update(password:, password_confirmation:)
        UserMailer
          .with(recipient: user)
          .password_reset_success

        return true
      else
        log "an error occurred while updating user's password"

        self.errors.add(
          :general,
          "Sorry, an unknown error occurred while resetting your password"
        )
      end
    end

    false
  end

  def to_partial_path
    "tokens/password_reset"
  end
end
