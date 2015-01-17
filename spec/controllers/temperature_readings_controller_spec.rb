require 'rails_helper'

RSpec.describe TemperatureReadingsController, :type => :controller do

  describe 'Given a parameter hash with a device' do
    before(:each) do
      @params = ActionController::Parameters.new({
        CelciusReading: '2',
        external_device_id: 'dev 03'
      })
    end

    it 'accept external_device' do
      expect {
        post :create, temperature_reading: @params
      }.to change(TemperatureReading, :count).by(1)
    end
  end

end
