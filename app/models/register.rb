class Register < ApplicationRecord
  validates :name, presence: true, format: { without: /\d/, message: "should not contain numbers" }, 
  length: { minimum: 2 }
  
  validates :branch, presence: true

  validates :year, presence: true, inclusion: { in: ['FE', 'SE', 'TE', 'BE'],
  message: "should be one of 'FE', 'SE', 'TE', 'BE'" }


  #has_many :events

  belongs_to :student
  belongs_to :event

  validates :student, presence: true
  validates :event, presence: true
end
