class TemperatureReading < ActiveRecord::Base
  belongs_to :device
  validates :CelciusReading, presence: true

  def external_device_id=(id)
    self.device = Device.find_or_create_by external_id: id
  end

  def external_device_id
    return nil unless self.device
    self.device.external_id
  end

  def fahrenheit
    return nil if self.CelciusReading.nil?
    TemperatureReading.toFahrenheit(self.CelciusReading)
  end

  def self.toFahrenheit(celcius)
    9.0 / 5.0 * celcius + 32
  end

  def self.latest
    TemperatureReading.last 
  end

  def self.get_summary(range = :all)
    case range
    when :today
      readings = TemperatureReading.where("created_at >= ?", Time.zone.now.beginning_of_day)
      readings = readings.map{|item| [item.created_at, item.CelciusReading]}.to_h
    when :all 
      readings = TemperatureReading.group_by_hour(:created_at).average(:CelciusReading)
    else
      if !!(range =~ /^hour(\d*)$/)
        readings = TemperatureReading.get_summary_hour(range) 
      else
        raise ArgumentError, 'Range of ' + range.to_s + ' is unknown'
      end
    end
    readings ||= {}
    readings.update(readings) {|time, celcius| TemperatureReading.toFahrenheit(celcius)} 
  end

  def self.get_summary_hour(range)
    time = range.to_s.scan(/\d/).join.to_i
    readings = TemperatureReading.where("created_at >= ?", Time.zone.now - time.hours)
    readings = readings.map{|item| [item.created_at, item.CelciusReading]}.to_h
    readings 
  end

  def self.archive!
    not_archived = TemperatureReading.all_before_today.where(:archived => false)
    grouped_by_hour = not_archived.group_by{|r| r.created_at.beginning_of_hour}
    grouped_by_hour.each{|t, items| TemperatureReading.create! :created_at => t,
                        :archived => true, :CelciusReading => (items.
                        inject(0){|total, r| total + r.CelciusReading} / items.count)}
    TemperatureReading.destroy(not_archived.pluck :id)
  end

  def self.DeleteOlderThenDays(days)
    oldItems = TemperatureReading.where.not(:created_at => ((Date.today - days).beginning_of_day..Date.today.end_of_day)) 
    TemperatureReading.destroy(oldItems.pluck :id)
  end

  def self.all_today
    TemperatureReading.where(:created_at => (Date.today.beginning_of_day..Date.today.end_of_day))
  end

  def self.all_before_today
    TemperatureReading.where.not(:created_at => (Date.today.beginning_of_day..Date.today.end_of_day))
  end

end
