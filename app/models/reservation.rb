class Reservation < ApplicationRecord

  self.primary_key = :registrationNumber

  enum reservationStatuses: [:active, :complete, :cancel]
  Hour_To_Sec = 3600
  Day_To_Hour = 24

  validates :reservationStatus, inclusion: {in: reservationStatuses}, null: false
  validates :user_id, null: false
  validates :car_id, null: false
  validates :checkOutTime, presence: true, null: false, inclusion: {in: (Time.zone.now..Time.zone.now+7*Day_To_Hour*Hour_To_Sec)}
  # validates :expectedReturnTime, presence: true, null: false, inclusion: {in: (:checkOutTime+1*Hour_To_Sec..:checkOUtTime+10*Hour_To_Sec)}

end
