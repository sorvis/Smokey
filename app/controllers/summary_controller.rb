class SummaryController < ApplicationController

  def index
    @latest = TemperatureReading.latest
  end

  def data
    render :json => TemperatureReading.get_summary
  end

end
