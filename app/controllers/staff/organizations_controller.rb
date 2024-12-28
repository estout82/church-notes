#
# Allows staff to manage organizations
#

class Staff::OrganizationsController < ApplicationController
  before_action :require_login!
  before_action :require_staff!
  before_action :require_organization, except: [:index]

  def index
    @organizations = Organization.all
  end

  def destroy
    ActiveRecord::Base.transaction do
      sub_ids = []

      # destroy accounts
      @organization.accounts.each do |account|
        if account.subscription.present?
          account.subscription.update! origin_account_id: nil

          sub_ids << account.subscription.id
        end

        account.destroy!
      end

      Subscription.where(id: sub_ids.uniq).each { |sub| sub.destroy! }
      @organization.users.each { |user| user.destroy! }
      @organization.destroy!

      render :destroy
    end
  end

  private

  #
  # actions
  #

  def require_staff!
    unless current_user.is_staff
      toast(
        "No",
        path: login_path,
        status: :not_found
      )
    end
  end

  def require_organization
    @organization = Organization.find(params[:id])
  end
end
