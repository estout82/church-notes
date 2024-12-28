#
# used in the sign-up process. creates all data needed for a functional
# account after a subscription.created hook is received
#

class Billing::SubscriptionCreator
  def initialize(subscription_id:, customer_id:, current_period_start:, current_period_end:)
    @subscription_id = subscription_id
    @customer_id = customer_id
    @cps = current_period_start
    @cpe = current_period_end
  end

  def run(plan:)
    customer = Stripe::Customer.retrieve(@customer_id)
    email = customer[:email]
    name = customer[:name]

    user = User.find_by!(email:)

    name_split = name.split(" ")

    first_name = name_split[0]
    last_name = name_split.slice(1..name_split.length).join(" ")

    User.update!(
      first_name: first_name,
      last_name: last_name,
      email: email,
    )

    subscription = Subscription.create!(
      stripe_subscription_id: @subscription_id
    )

    account = Account.create!(
      organization: user.organization,
      subscription:,
      name: "Main",
      is_main: true
    )

    user_account_member = UserAccountMember.create!(
      user:,
      account:,
      is_default: true
    )

    user_account_member_owner = UserAccountMemberRole.create!(
      user_account_member:,
      role: :owner
    )
  end
end
