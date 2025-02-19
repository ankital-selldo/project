class Club < ApplicationRecord

  validates :club_name, presence: true


  belongs_to :student

  has_many :events

end