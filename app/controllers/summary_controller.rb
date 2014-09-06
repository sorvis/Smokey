class SummaryController < ApplicationController
  def index
    @latest = TemperatureReading.latest
    @summary_data = TemperatureReading.get_summary
  end
end
