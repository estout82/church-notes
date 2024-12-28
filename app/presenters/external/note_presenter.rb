#
# Contains view logic for external notes
#

class External::NotePresenter
  def initialize(note, instance: nil)
    @note = note
    @instance = instance
  end

  def banner_url
    # Attached poster images take precedence

    @banner_url ||= @note.banner.attached? ?
      @note.banner.url :
      @note.banner_url
  end

  def has_banner?
    banner_url.present?
  end

  def instance_values_json
    if @instance.present?
      @instance.serialize.to_json
    else
      [].to_json
    end
  end

  def instance_id
    @instance&.id
  end
end
