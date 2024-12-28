#
# Responsible for creating a new token
#

class Security::TokenCreator
  def initialize(user:, action: nil)
    @user = user
    @action = action
  end

  def run
    Token
      .where(user_id: @user.id, action: @action)
      .destroy_all
    
    secure_value = SecureRandom.alphanumeric(256)

    # NOTE all tokens are password resets for now
    Token.create!(
      user_id: @user.id,
      value: secure_value,
      action: @action,
      active: true,
      type: "Tokens::PasswordReset"
    )
  end
end
