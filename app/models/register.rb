class Register < ApplicationRecord
  # Validations for 'name' attribute
  validates :name, presence: true, format: { without: /\d/, message: "should not contain numbers" }, 
  length: { minimum: 2 }
  
  # Validations for 'branch' attribute
  validates :branch, presence: true

  # Validations for 'year' attribute (assuming it's a valid year like "1st", "2nd", "3rd", etc.)
  validates :year, presence: true, format: { with: /\A\d{1,2}[a-z]{2}\z/i,
  message: "should be in '1st', '2nd', '3rd', etc. format" }

  # Associations (already defined in the migration)
  belongs_to :student
  belongs_to :event

  # Validate that a registration is associated with a valid event and student
  validates :student, presence: true
  validates :event, presence: true
end
