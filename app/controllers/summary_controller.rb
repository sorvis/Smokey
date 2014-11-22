class SummaryController < ApplicationController

  def index
    @dataRange = params[:dataRange]
    redirect_to(:action => 'index', :dataRange => 'today') unless @dataRange
  end

  def latest
    latestReading = TemperatureReading.latest
    json = {:created_at => latestReading.created_at, :fahrenheit => latestReading.fahrenheit}
    render :json => json
  end

  def data
    @dataRange = params[:dataRange] || :today
    render :json => TemperatureReading.get_summary(@dataRange.to_sym)
  end

end
