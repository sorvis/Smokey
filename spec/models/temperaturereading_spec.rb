require 'rails_helper'

describe 'Given an external_device' do
  before(:each) do
    @device = Device.create :external_id => 'test'
  end

  it 'should create a reading on that device' do
    expect{reading = TemperatureReading.create :CelciusReading => 3, 
            :external_device_id => @device.external_id
    }.to change(@device.temperatureReadings, :count).by(1)
  end
end

describe 'Given TemperatureReadings with a parent device' do
  before(:each) do
    @device = Device.create
    @reading = @device.temperatureReadings.create :CelciusReading => 2
  end

  it 'should have the same device_id as the parent device record' do
    expect(@reading.device_id).to eq @device.id
  end

  it 'should be deleted when the device is deleted' do
    expect { @device.destroy }.
      to change(TemperatureReading, :count).by(-1)
  end
end

describe 'Given a temperature of 38.2 celcius' do
  before(:each) do
    @temperature = TemperatureReading.create :CelciusReading => 38.2
    @fahrenheit = 100.76
  end

  it 'should have fahrenheit of 100.76' do 
    expect(@temperature.fahrenheit).to eq @fahrenheit
  end

  it 'should return summary in fahrenheit' do
    TemperatureReading.get_summary.first.map{|k,v|v}.first == @fahrenheit
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

describe 'Given data in every week for the past month get_summary :today' do
  before(:each) do
    TemperatureReading.delete_all
    @today = TemperatureReading.create! :created_at => DateTime.now.noon, :CelciusReading => Random.rand()
    @yesterday = TemperatureReading.create! :created_at => Date.yesterday, :CelciusReading => Random.rand()
    @yesturday_noon = TemperatureReading.create :created_at => DateTime.yesterday.noon, :CelciusReading => Random.rand()
    TemperatureReading.create :created_at => DateTime.yesterday.noon, :CelciusReading => Random.rand()
  end

  it 'should return only today for today' do
    @result = TemperatureReading.get_summary(:today)
    @result.each{|key, value| key.to_date.should eq Date.today}
  end

  it 'should contain todays temperature' do
    @result = TemperatureReading.get_summary(:today)
    expect(@result.values).to include(@today.fahrenheit)
  end

  it 'should not contain more data then there exists for today' do
    @result = TemperatureReading.get_summary(:today)
    numberToday = TemperatureReading.where("created_at >= ?", Time.zone.now.beginning_of_day).count
    expect(@result.count).to equal(numberToday)
  end
end

describe 'Given data 25, 23, and 5 hours ago get_summary_hour :hour' do
  before(:each) do
    TemperatureReading.delete_all
    @fiveHours = TemperatureReading.create! :created_at => (Time.zone.now - 5.hours), :CelciusReading => Random.rand()
    @twentyThreeHours = TemperatureReading.create! :created_at => (Time.zone.now - 23.hours), :CelciusReading => Random.rand() 
    @twentyFiveHours = TemperatureReading.create! :created_at => (Time.zone.now - 25.hours), :CelciusReading => Random.rand() 
  end

  it 'should return only 2 records for the last 24 hours' do
    @result = TemperatureReading.get_summary_hour(:hour24)
    expect(@result.count).to equal(2)
  end
end

describe 'Given no data get_summary' do
  before(:each) do
    TemperatureReading.delete_all
  end
  it 'should work for :all' do
    TemperatureReading.get_summary(:all)
  end
  it 'should work for :today' do
    TemperatureReading.get_summary(:today)
  end
  it 'should call get_summary_hour for :hour12' do
    TemperatureReading.should_receive(:get_summary_hour)
    TemperatureReading.get_summary(:hour12)
  end
  it 'should throw an argument expection for :invalidValue' do
    expect{
      TemperatureReading.get_summary(:invalidValue)
    }.to raise_error(ArgumentError)
  end
end

describe 'Given data before today and today archive' do
  before(:each) do
    TemperatureReading.delete_all
    @today = TemperatureReading.create! :created_at => DateTime.now.noon, :CelciusReading => Random.rand()
    @yesterday = TemperatureReading.create! :created_at => Date.yesterday, :CelciusReading => Random.rand()
    @yesturday_noon = TemperatureReading.create :created_at => DateTime.yesterday.noon, :CelciusReading => Random.rand()
  end

  it 'should mark yesterdays data as being archived' do
    TemperatureReading.archive!
    TemperatureReading.all_before_today.each{|r| expect(r.archived).to eq(true)}
  end

  it 'should leave todays intact' do
    expect{ TemperatureReading.archive! }.not_to change {TemperatureReading.all_today}
  end

  it 'should archive yesterdays data into 24 records' do
    25.times{|i| TemperatureReading.create :created_at => DateTime.yesterday.beginning_of_day + (i-1).hour, :CelciusReading => Random.rand()}
    TemperatureReading.archive!
    TemperatureReading.where(created_at: (DateTime.yesterday.
                                          beginning_of_day)..DateTime.
                                          yesterday.end_of_day).count.should be 24
  end
end


