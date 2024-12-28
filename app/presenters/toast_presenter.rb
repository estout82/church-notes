#
# Presenter for the toast notification system (flash messages)
#

class ToastPresenter
  def initialize(level)
    @level = level
  end

  def background_color
    case @level
    when :success
      "bg-success"
    when :error
      "bg-error"
    when :info
      "bg-info"
    end
  end
end