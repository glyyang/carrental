class Reservation < ApplicationRecord

  enum reservationStatus: [:Active, :Complete, :Cancel]

  validates :reservationStatus, inclusion: {in: reservationStatuses}
  validates :checkOutTime, presence: true

end
