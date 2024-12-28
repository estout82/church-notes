# frozen_string_literal: true

require "json"

# Allows completed notes to be converted to a pdf and downloaded
class External::Notes::DownloadsController < External::BaseController
  layout "pdf"

  before_action :set_note!
  after_action :store_interaction

  def new
    fill_in_values_object = JSON.parse params[:fill_in_values]

    @renderer = Note::EmailRenderer.new(
      note: @note,
      fill_in_values: fill_in_values_object.map do |value|
        External::Notes::Email::FillInValue.new(
          id: value["id"],
          value: value["value"]
        )
      end
    )

    html = render_to_string(
      action: :show,
      layout: "pdf"
    )

    pdf = WickedPdf.new.pdf_from_string(html)

    send_data(
      pdf,
      filename: "note.pdf",
      disposition: "attachment"
    )
  end

  private

  #
  # actions
  #

  def set_note!
    @note = Note.find_by! alt_id: params[:note_alt_id]
  end

  def store_interaction
    HandleNoteDownloadJob.perform_later(
      user: current_user,
      note: @note
    )
  end
end
