class Event < ApplicationRecord

  mount_uploader :event_image, EventUploader

  validates :event_name, :event_venue, :event_time, :event_date, :event_deadline, :event_register_link, :club_id, presence: true

  validates :event_desc, length: { minimum: 10, message: "should have at least 10 characters" }

  validates :event_image, allow_blank: true, format: { with: /\A.*\.(jpg|jpeg|png|gif)\z/i, message: "must be a valid image format (jpg, jpeg, png, gif)" }

  validates :event_register_link, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }

  belongs_to :club

  has_many :registers, dependent: :destroy

  #belongs_to :register

  validate :event_date_not_in_past
  validate :event_deadline_not_before_event_date

  private

  # Ensure event_deadline is not in the past or earlier than event_date
  def event_deadline_not_before_event_date
    if event_deadline.to_date < Date.today
      errors.add(:event_deadline, "cannot be in the past")
    elsif event_deadline.present? && event_date.present? && event_deadline.to_date < event_date
      errors.add(:event_deadline, "cannot be before event date")
    end
  end

  # Ensure event_date is not in the past
  def event_date_not_in_past
    if event_date.present? && event_date <= Date.today
      errors.add(:event_date, "cannot be in the past")
    end
  end
end