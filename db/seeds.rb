# frozen_string_literal: true

# Sets up the development DB

def create_user(first:, last:, email:, organization:, account:, role:)
  owner = User.create!(
    first_name: first,
    last_name: last,
    email:,
    password: "1234",
    password_confirmation: "1234"
  )

  organization.users << owner

  member = UserAccountMember.create!(
    user: owner,
    account:
  )

  UserAccountMemberRole.create(
    user_account_member: member,
    role:
  )
end

organization = Organization.create!(
  name: "Cornerstone Church",
  encoded_name: "cornerstone_church",
  plan: :multisite
)

main_account = Account.create!(
  organization:,
  name: "Main Account",
  is_main: true
)

#
# create owner
#

create_user(
  first: "Sterling",
  last: "Jones",
  email: "sterling@cornerstone.church",
  organization:,
  account: main_account,
  role: :owner
)

#
# create editor
#

create_user(
  first: "Editor",
  last: "Jones",
  email: "editor@cornerstone.church",
  organization:,
  account: main_account,
  role: :editor
)

#
# create scheduler
#

create_user(
  first: "Scheduling",
  last: "Jones",
  email: "scheduling@cornerstone.church",
  organization:,
  account: main_account,
  role: :scheduling
)

#
# create admin
#

create_user(
  first: "Admin",
  last: "Jones",
  email: "admin@cornerstone.church",
  organization:,
  account: main_account,
  role: :admin
)
