class Student < ApplicationRecord

  has_secure_password

  validates :name, presence: true, length: {minimum: 3}, format: {
    with: /\A[^0-9]*\z/,  
    message: "cannot contain numbers"
  }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, 
  message: "invalid format" }

  validates :password, presence: true, length: { minimum: 6 }, format: {
    with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).*\z/, 
    message: "must include at least one uppercase letter, one lowercase letter, one number, and one special character"
  }
  

  validates :role, presence: true, inclusion: {in: %w[user admin club_head], message: "not valid"}

  #Associations
  has_many :registers


  has_many :clubs

end