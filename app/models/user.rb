class User < ApplicationRecord

  has_secure_password

  enum role: [:Customer, :Admin, :SuperAdmin]

  validates :name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :role, presence: true, default: :Customer, inclusion: {in: roles}

end
