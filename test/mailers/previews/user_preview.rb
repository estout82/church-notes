class UserPreview < ActionMailer::Preview
  def welcome
    UserMailer
      .with(
        recipient: User.last,
        token: Security::TokenCreator.new(user: User.last).run
      )
      .welcome
  end

  def password_reset
    UserMailer
      .with(
        recipient: User.last,
        token: Security::TokenCreator.new(user: User.last).run
      )
      .password_reset
  end

  def password_reset_success
    UserMailer
      .with(recipient: User.last)
      .password_reset_success
  end
end