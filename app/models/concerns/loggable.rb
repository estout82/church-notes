#
# Allows for log formatting in classes
#

module Loggable
  extend ActiveSupport::Concern

  included do |base|
    self.prefix = base.to_s
  end

  def log(message, level: :info)
    self.class.log(message, level:)
  end

  module ClassMethods
    def prefix
      @prefix || "NotesPro"
    end

    def prefix=(value)
      @prefix = value
    end

    def log(message, level: :info)
      logger = Rails.logger
      logger.tagged(prefix) { logger.send(level, message) }
    end
  end
end