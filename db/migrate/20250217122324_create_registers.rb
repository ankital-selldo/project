class CreateRegisters < ActiveRecord::Migration[8.0]
  def change
    create_table :registers do |t|
      t.references :student, null: false, foreign_key: true    
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
