# frozen_string_literal: true

#
# Runs all side-effects that need to take place after creating a user
#
class UserCreateHandler
  attr_accessor :user

  def initialize(user:)
    @user = user
  end

  def run(account: nil)
    if account.present?
      account.add_member(
        user:,
        roles: [:editor, :scheduling]
      )
    end

    token = Security::TokenCreator
      .new(user: @user)
      .run

    UserMailer
      .with(recipient: @user, token:)
      .welcome
      .deliver_later
  end
end
