class CreateClubs < ActiveRecord::Migration[8.0]
  def change
    create_table :clubs do |t|
      t.string :club_name, null: false
      t.text :club_description
      t.string :club_logo

      t.timestamps
    end
  end
end
