class Club < ApplicationRecord

  mount_uploader :club_logo, ClubUploader

  validates :club_name, presence: true

  validates :club_logo, presence: true, allow_blank: true


  belongs_to :student
  
  has_many :events, dependent: :destroy
  
  
end