# frozen_string_literal: true

# Allows all users to view organizations (ie churches)
class External::OrganizationsController < External::BaseController
  before_action :set_organization!

  def show
    account = @organization.main_account

    @main_account_live_notes = LiveNoteDecider.new(account:).run
    @past_notes = PastNoteDecider.new(account:).run
  end

  private

  def set_organization!
    id = params[:id]

    @organization = Organization.find_by! encoded_name: id
    current_external_organization_is @organization
  end
end
