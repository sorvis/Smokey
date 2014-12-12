json.array!(@devices) do |device|
  json.extract! device, :id, :external_id, :title, :description
  json.url device_url(device, format: :json)
end
