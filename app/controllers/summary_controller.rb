class SummaryController < ApplicationController

  def index
    @dataRange = params[:dataRange]
    redirect_to(:action => 'index', :dataRange => 'today') unless @dataRange

    @latest = TemperatureReading.latest
  end

  def data
    @dataRange = params[:dataRange] || :today
    render :json => TemperatureReading.get_summary(@dataRange.to_sym)
  end

end
