class Car < ApplicationRecord

  enum styles: [:Coupe, :Sedan, :SUV]
  enum statuses: [:CheckedOut, :Available]

  validates :licensePlateNumber, presence: true, uniqueness: {case_sensitive: false}, length: {is: 7}, null: false
  validates :manufacturer, presence: true, null: false
  validates :model, presence: true, null: false
  validates :hourlyRentalRate, presence: true, numericality: { greater_than_or_equal_to: 0 }, null: false
  validates :style, presence: true, inclusion: {in: styles}, null: false
  validates :location, presence: true, null: false
  validates :status, presence: true, inclusion: {in: statuses}, null: false

end
