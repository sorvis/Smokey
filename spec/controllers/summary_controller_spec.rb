require 'rails_helper'

RSpec.describe SummaryController, :type => :controller do

  describe "GET index" do
    before(:each) do
      TemperatureReading.create! :CelciusReading => 4
    end
    it "returns http success" do
      get :index
      expect(response).to be_success
    end

    it 'should set @latest' do
      get :index
      assigns(:latest).should_not be_nil
    end

    it 'should call TemperatureReading.latest' do
      TemperatureReading.should_receive(:latest)  
      get :index
    end
  end
end
