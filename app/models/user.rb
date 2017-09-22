class User < ApplicationRecord

  before_save {email.downcase!}
  
  enum roles: [:Customer, :Admin, :SuperAdmin]
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
                    format: { with: VALID_EMAIL_FORMAT },
                    uniqueness: { case_sensitive: false }
  validates :role, inclusion: { in: roles }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def admin?
    self.role == 'Admin'
  end

end
