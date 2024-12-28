module NavHelper
  def nav_item_class(page)
    if page_selected? page
      return "text-primary"
    end

    return "text-muted"
  end

  private

  def page_selected?(page)
    @current_page&.to_sym == page.to_sym
  end
end
