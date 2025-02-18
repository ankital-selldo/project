class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :role, default: "student"

      t.timestamps
    end
    add_index :students, :email, unique: true
  end
end
