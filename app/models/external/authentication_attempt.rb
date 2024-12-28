# frozen_string_literal: true

# Responsible for authenticating an external user
class External::AuthenticationAttempt
  include ActiveModel::Model

  attr_accessor :email, :password

  def self.from_params(params)
    new(email: params[:email].downcase, password: params[:password])
  end

  def authenticated?
    if user.present? && user.authenticate(password)
      true
    else
      errors.add :base, "Incorrect email or password"
      false
    end
  end

  def user
    @user ||= User.find_by(email:)
  end
end
