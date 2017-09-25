class ReturnCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    reservation_id = args[0]
    reservation = Reservation.find(reservation_id)
    if reservation.reservationStatus == "Active"
      reservation.update_attributes(:reservationStatus => "Complete")
      car = Car.find(reservation.car_id)
      user = User.find(reservation.user_id)
      notice = "You are late to return the car"
      car.update_attributes(:status => "Available")
      user.update_attributes(:notification => notice)
    end
  end
end
