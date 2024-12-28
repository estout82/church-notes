module DateHelper
  def utc_offset(timezone:)
    (Time.current.in_time_zone(timezone).utc_offset / 60 / 60).to_s
  end

  def day_ordinal_suffix(day)
    if [11, 12, 13].include?(day % 100)
      "th"
    else
      case day % 10
      when 1 then "st"
      when 2 then "nd"
      when 3 then "rd"
      else "th"
      end
    end
  end

  def date_time_formatted(date)
    date.strftime("%b %-d#{day_ordinal_suffix(date.day)}, %Y %-l:%M%p")
  end
end
