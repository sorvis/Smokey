class SummaryController < ApplicationController

  def index
    @dataRange = params[:dataRange]
    redirect_to(:action => 'index', :dataRange => 'today') unless @dataRange
  end

  def latest
    render :json => TemperatureReading.latest
  end

  def data
    @dataRange = params[:dataRange] || :today
    render :json => TemperatureReading.get_summary(@dataRange.to_sym)
  end

end
