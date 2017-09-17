json.extract! car, :id, :licensePlateNumber, :manufacturer, :model, :hourRentalRate, :style, :location, :status, :created_at, :updated_at
json.url car_url(car, format: :json)
