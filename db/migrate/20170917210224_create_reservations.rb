class CreateReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.string :registrationNumber, null: false
      t.timestamp :checkOutTime
      t.timestamp :pickUpTime
      t.timestamp :expectedReturnTime
      t.timestamp :returnTime
      t.string :reservationStatus

      t.references :user
      t.references :car
      t.timestamps
    end
    add_index :reservations, :registrationNumber, :unique => true
  end
end
