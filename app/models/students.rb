class Student < ApplicationRecord

  has_many :registers
  
  has_and_belongs_to_many :clubs

end