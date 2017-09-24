class Car < ApplicationRecord
    
  enum styles: [:Coupe, :Sedan, :SUV]
  enum statuses: [:CheckedOut, :Available]

  validates :licensePlateNumber, presence: true, uniqueness: {case_sensitive: false}, length: {is: 7}
  validates :manufacturer, presence: true
  validates :model, presence: true
  validates :hourlyRentalRate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :style, presence: true, inclusion: {in: styles}
  validates :location, presence: true
  validates :status, presence: true, inclusion: {in: statuses}
    
  # Conditionally search car in database
  # def self.search(condition)
  #   if condition
  #     where("location LIKE ? AND style LIKE ?", "%#{condition[:location]}%", "#{condition[:style]}").order('id ASC')
  #   else 
  #     order('id ASC')
  #   end
  # end
  
end
