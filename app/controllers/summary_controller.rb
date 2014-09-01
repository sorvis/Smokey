class SummaryController < ApplicationController
  def index
    @latest = TemperatureReading.latest
  end
end
