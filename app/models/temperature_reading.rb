class TemperatureReading < ActiveRecord::Base
  validates :CelciusReading, presence: true

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
      readings = TemperatureReading.group_by_hour(:created_at, 
        range: Date.today.beginning_of_day..Date.today.end_of_day).average(:CelciusReading)
    when :all
      readings = TemperatureReading.group_by_hour(:created_at).average(:CelciusReading)
    end
    readings.update(readings) {|time, celcius| TemperatureReading.toFahrenheit(celcius)} 
  end

  def self.archive!
    not_archived = TemperatureReading.all_before_today.where(:archived => false)
    grouped_by_day = not_archived.group_by{|r| r.created_at.to_date}
    grouped_by_day.each{|t, items| TemperatureReading.create! :created_at => t,
                        :archived => true, :CelciusReading => (items.
                        inject(0){|total, r| total + r.CelciusReading} / items.count)}
    TemperatureReading.destroy(not_archived.pluck :id)
  end

  def self.all_today
    TemperatureReading.where(:created_at => (Date.today.beginning_of_day..Date.today.end_of_day))
  end

  def self.all_before_today
    TemperatureReading.where.not(:created_at => (Date.today.beginning_of_day..Date.today.end_of_day))
  end

end
