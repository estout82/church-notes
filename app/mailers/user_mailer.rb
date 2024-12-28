#
# Emails sent to users
#

class UserMailer < ApplicationMailer
  def welcome
    @user = params[:recipient]
    @token = params[:token]

    mail to: @user.email, subject: "Your NotesPro Account"
  end

  def password_reset
    @user = params[:recipient]
    @token = params[:token]

    mail to: @user.email, subject: "Reset Your Password"
  end

  def password_reset_success
    @user = params[:recipient]

    mail to: @user.email, subject: "You've Reset Your Password"
  end
end
