class Reservation < ApplicationRecord
    
  require 'date'
  enum reservationStatuses: [:Awaiting, :Active, :Complete, :Cancel]

  validates :reservationStatus, inclusion: {in: reservationStatuses}
  validates :checkOutTime, presence: true
    
end
