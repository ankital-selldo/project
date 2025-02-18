class Event < ApplicationRecord

  has_many :registers

  belongs_to :club
  
end