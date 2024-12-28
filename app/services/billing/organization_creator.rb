# frozen_string_literal: true

#
# Creates an organization and user as part of the initial check out process.
# the full account setup is completed after payment is completed.
#
class Billing::OrganizationCreator
  def initialize(name:, plan:, email:, password:, password_confirmation:)
    @name = name
    @plan = plan
    @email = email
    @password = password
    @password_confirmation = password_confirmation
  end

  def run
    organization = Organization.create!(
      name: @name,
      encoded_name: Organization.encode_name(@name),
      plan: @plan
    )

    user = User.create!(
      email: @email,
      password: @password,
      password_confirmation: @password_confirmation
    )

    user.organizations << organization

    user
  end
end
