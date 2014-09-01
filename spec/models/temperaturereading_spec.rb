require 'rails_helper'
#require 'ruby-debug'

describe 'Given a temperature of 38.2 celcius' do
  before(:each) do
    @temperature = TemperatureReading.new :CelciusReading => 38.2
  end

  it 'should have fahrenheit of 100.76' do 
    expect(@temperature.fahrenheit).to eq 100.76
  end
end

describe 'Given a nil temperature' do
  before(:each) do
    @temperature = TemperatureReading.new :CelciusReading => nil
  end

  it 'should not blow up on fahrenheit' do
    expect(@temperature.fahrenheit).to eq(nil)
  end

  it 'should throw validation error on save' do
    expect{@temperature.save!}.to raise_error
  end
end

describe 'Given an older and newer reading latest' do
  before(:each) do
    @newer = TemperatureReading.create! :created_at => DateTime.now.noon, :CelciusReading => 13
    @older = TemperatureReading.create! :created_at => DateTime.now.midnight, :CelciusReading => 44
  end

  it 'should should return newer' do
    expect(TemperatureReading.latest).to eq(@older)
  end
end


