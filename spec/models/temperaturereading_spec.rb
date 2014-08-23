require 'spec_helper'

describe 'Given a temperature of 38.2 celcius' do
  before(:each) do
    @temperature = TemperatureReading.new :CelciusReading => 38.2
  end

  it 'should have fahrenheit of 100.76' do 
    @temperature.should == 100.76
  end
end

