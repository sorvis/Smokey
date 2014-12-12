class Device < ActiveRecord::Base
  has_many :temperatureReadings, dependent: :destroy
end
