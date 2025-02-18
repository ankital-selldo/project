class Club < ApplicationRecord

  belongs_to :student

  has_many :events

end