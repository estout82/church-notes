#
#
#

require "json"

class External::Notes::Download
  include ActiveModel::Model

  def generate(note:)
    Prawn::Document.generate("example.pdf") do
      # title

      font_size 24
      text note.title
    end
  end
end
