#
# Represents a password reset form
#
# TODO actually check the email
# 
# TODO maybe make some method that encapsulates the details of actually
# creating the token and such
#

class PasswordReset
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: true

  validates :email,
    format: {
      with: URI::MailTo::EMAIL_REGEXP,
      message: "Email is invalid"
    }

  def save
    user = User.find_by(email:)

    unless user.present?
      self.errors.add(
        :general,
        "Sorry, we couldn't find a user with that email"
      )

      return false
    end

    token = Security::TokenCreator.new(user:).run

    unless token.present?
      self.errors.add(
        :general,
        "Sorry, we are having trouble generating your password reset"
      )

      return false
    end

    UserMailer
      .with(recipient: user, token:)
      .password_reset
      .deliver_later

    true
  end
end
