class CreateClubs < ActiveRecord::Migration[8.0]
  def change
    create_table :clubs do |t|
      t.references :student, null: false, foreign_key: true

      t.string :club_name
      t.string :club_logo
      t.timestamps
    end
  end
end