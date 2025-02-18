class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|

      t.string :event_name
      t.text :event_desc
      t.string :event_image

      t.string :event_venue
      t.time :event_time
      t.date :event_date
      t.datetime :event_deadline
      t.string :event_register_link, array: true, default: []

      t.references :club, null: false, foreign_key: true
      t.timestamps
    end
  end
end