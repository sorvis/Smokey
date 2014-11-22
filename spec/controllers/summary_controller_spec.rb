require 'rails_helper'

RSpec.describe SummaryController, :type => :controller do

  describe "GET index" do
    before(:each) do
      TemperatureReading.create! :CelciusReading => 4
    end

    it "returns http success" do
      get :index, :dataRange => "all"
      expect(response).to be_success
    end
  end

  describe "GET latest" do
    before(:each) do
      TemperatureReading.create! :CelciusReading => 4
    end

    it 'should call TemperatureReading.latest' do
      TemperatureReading.should_receive(:latest)  
      get :latest
    end
  end

  describe "GET data" do
    before(:each) do
      @data = TemperatureReading.create! :CelciusReading => 4
    end

    it 'should call TemeratureReading.get_summary' do
      TemperatureReading.should_receive(:get_summary)
      get :data
    end
  end
end
