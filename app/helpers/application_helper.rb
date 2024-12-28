module ApplicationHelper
  
  def current_host
    case Rails.env
    when "production"
      return "app.notespro.church"
    when "test"
      return "localhost:5501"
    when "development"
      return "localhost:5501"
    end
  end

  def current_scheme
    case Rails.env
    when "production"
      return "https://"
    when "test"
      return "http://"
    when "development"
      return "http://"
    end
  end
end
