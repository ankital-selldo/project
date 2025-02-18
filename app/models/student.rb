class Student < ApplicationRecord

  has_many :registers

  has_many :clubs

end