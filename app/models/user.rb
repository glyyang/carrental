class User < ApplicationRecord

  has_secure_password

  enum roles: [:Customer, :Admin, :SuperAdmin]

  validates :name, presence: true, null: false
  validates :email, presence: true, uniqueness: {case_sensitive: false}, null: false
  validates :role, presence: true, inclusion: {in: roles}, null: false

end
