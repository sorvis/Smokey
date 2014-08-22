require 'test_helper'

class TemperatureReadingsControllerTest < ActionController::TestCase
  setup do
    @temperature_reading = temperature_readings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:temperature_readings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create temperature_reading" do
    assert_difference('TemperatureReading.count') do
      post :create, temperature_reading: { CelciusReading: @temperature_reading.CelciusReading }
    end

    assert_redirected_to temperature_reading_path(assigns(:temperature_reading))
  end

  test "should show temperature_reading" do
    get :show, id: @temperature_reading
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @temperature_reading
    assert_response :success
  end

  test "should update temperature_reading" do
    patch :update, id: @temperature_reading, temperature_reading: { CelciusReading: @temperature_reading.CelciusReading }
    assert_redirected_to temperature_reading_path(assigns(:temperature_reading))
  end

  test "should destroy temperature_reading" do
    assert_difference('TemperatureReading.count', -1) do
      delete :destroy, id: @temperature_reading
    end

    assert_redirected_to temperature_readings_path
  end
end
