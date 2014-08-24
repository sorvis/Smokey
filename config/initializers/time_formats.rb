#Time::DATE_FORMATS[:time_and_date]  = ->(time) { time.strftime("%I:%M %p %a %-m/%e/%Y") }
Time::DATE_FORMATS[:time_and_date]  = "%l:%M %p %a %-m/%e/%Y"
