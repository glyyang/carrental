class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name
      t.string :role, default: "Customer"
      t.float :rentalCharge, default: 0.0
      t.string :notification, default: "You can reserve a car!"

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_column :users, :password_digest, :string
  end
end
