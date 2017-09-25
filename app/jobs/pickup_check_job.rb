class PickupCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    reservation_id = args[0]
    reservation = Reservation.find(reservation_id)
    if reservation.reservationStatus == "Awaiting"
      reservation.update_attributes(:reservationStatus => "Cancel")
    end
  end
end