#
# Base class for external controllers. External controllers handle things like
# current logged in user or current organization / account.
#

class External::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :allow_all_iframe_origins
  before_action :set_current_external_organization
  after_action :save_previous_path

  helper_method :current_external_organization, :is_external?

  layout "external"

  #
  # helpers
  #

  attr_accessor :current_external_organization

  def is_external?
    true
  end

  def previous_path
    session[:previous_path]
  end

  def current_external_organization_is(organization)
    self.current_external_organization = organization
    cookies.signed[:external_organization_id] = organization.id
    session[:external_organization_id] = organization.id
  end

  def set_current_external_organization
    id = session[:external_organization_id].presence || cookies.signed[:external_organization_id].presence
    self.current_external_organization = Organization.find_by(id:) if id
  end

  def require_external_login!
    raise ExternalLoginRequired if current_user.blank?
  end

  private

  #
  # actions
  #

  def allow_all_iframe_origins
    response.headers.delete "X-Frame-Options"
  end

  def save_previous_path
    session[:previous_path] = request.original_fullpath
  end

  class ExternalLoginRequired < StandardError; end
end
