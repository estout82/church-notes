#
# Represents the form to add a new member to an account. Sort of an adapter
# between a user account member and a regular user entity when dealing with
# users in the context of a single account.
#

class Accounts::Members::NewMemberForm
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :email, :account, :new_member

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  validates :email,
    format: {
      with: URI::MailTo::EMAIL_REGEXP,
      message: "Email is invalid"
    },
    allow_blank: true

  #
  # Saves the form data into the data model.
  # - Will create a UserAccountMember if user with email already exists
  # - Otherwise, will create a user and also add them to account
  #
  def save
    return false unless valid?

    raise MissingAccountError if account.blank?

    @user = find_or_create_user

    if @user.present?
      self.new_member = UserAccountMember.create(
        account:,
        user: @user
      )

      new_member.save!
    else
      false
    end
  end

  private

  def find_or_create_user
    user = User.find_by(email:)

    if user.blank?
      secure_random_pw = SecureRandom.alphanumeric(20)

      user = User.new(
        email:,
        first_name:,
        last_name:,
        password: secure_random_pw,
        password_confirmation: secure_random_pw
      )

      user.organizations << account.organization

      unless user.save
        # creating user failed

        errors.add :base, "Sorry, something went wrong while adding that user"
        return
      end

      UserCreateHandler.new(user:).run
    end

    unless user.organizations.include?(account.organization)
      # Can't add user because user belongs to another account
      errors.add :base,
        "Sorry, you can't add that user: a user's account with that email belongs to another organization on NotesPro"
      return
    end

    user
  end

  #
  # Raised if the form is saved without a provided account
  #
  class MissingAccountError < StandardError; end
end
