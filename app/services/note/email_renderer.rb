# frozen_string_literal: true

#
# Renders notes for emails
#
class Note::EmailRenderer
  attr_accessor :note, :fill_in_values, :current_fill_in_index

  def initialize(note:, fill_in_values:)
    self.note = note
    self.fill_in_values = fill_in_values
    self.current_fill_in_index = 0
  end

  def render_html(html:)
    parsed_content = Nokogiri.HTML5 html
    fill_in_selector = ".cdx-fill-in"

    while parsed_content.at_css(fill_in_selector).present?
      element = parsed_content.at_css(fill_in_selector)
      value_text = yield_next_fill_in&.dig(:value)
      element.replace("<span style='color: #808091; padding: 2px 8px; border-radius: 8px; background: lightgrey; margin: 0 3px;'>#{value_text}</span>")
    end

    parsed_content.at("body").inner_html
  end

  private

  def yield_next_fill_in
    value = fill_in_values.at(current_fill_in_index)
    self.current_fill_in_index += 1

    value
  end
end
