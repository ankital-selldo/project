class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.text :description
      t.string :event_image
      t.references :club, null: false, foreign_key: true


      t.timestamps
    end
  end
end
