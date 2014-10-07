require 'rails_helper'
#require 'ruby-debug'

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

  describe 'Given data in every week for the past month get_summary' do
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
end


