class Event < ApplicationRecord

  belongs_to :club

  has_many :registers
  
end