json.extract! reservation, :id, :registrationNumber, :checkOutTime, :pickUpTime, :expectedReturnTime, :returnTime, :reservationStatus, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
