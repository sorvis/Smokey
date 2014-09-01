class SummaryController < ApplicationController
  def index
    @latest = TemperatureReading.new :CelciusReading =>  9.9
  end
end
