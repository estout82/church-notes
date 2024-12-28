#
# Responsible for managing note banners.
#

class Notes::BannersController < ApplicationController
  before_action :require_login!
  before_action :set_note!
  before_action :require_manage_permission!

  def show; end

  def edit
    @query = params.fetch(:query, nil)

    @results = if @query.present?
      Unsplash::Photo.search(
        @query,
        1,
        12,
        :landscape
      )
    else
      Unsplash::Photo.random(
        query: "church",
        count: 24,
        orientation: :landscape
      )
    end
  end

  def update
    @note.banner.purge if @note.update update_params
  end

  def new; end

  def create
    # handles file uploads

    if @note.update create_params
      respond_to :turbo_stream
    else
      toast(
        "Something went wrong setting the banner",
        status: :unprocessable_entity
      )
    end
  end

  def destroy
    if @note.update(banner_url: nil, banner: nil)
      respond_to :turbo_stream
    else
      toast(
        "Something went wrong while removing the banner",
        status: :unprocessable_entity
      )
    end
  end

  private

  #
  # actions
  #

  def set_note!
    @note = Note.find_by! alt_id: params[:note_alt_id]
  end

  def require_manage_permission!
    @policy = @note.policy(
      user: current_user,
      account: current_account
    )

    unless @policy.can_manage?
      toast(
        "Sorry, you're not allowed to update that note",
        status: :unauthorized
      )
    end
  end

  #
  # params
  #

  def update_params
    params
      .require(:note)
      .permit(:banner_url)
  end

  def create_params
    params
      .require(:note)
      .permit(:banner)
  end
end
