module DatesHelper
  def date_time_to_format(date, timezone=Time.zone.name)
    date.in_time_zone(timezone).strftime("%m/%d/%Y %I:%M:%S %p")
  end
end
