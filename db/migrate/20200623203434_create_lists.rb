class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.string :name
      t.integer :pos
      t.boolean :closed, default: false
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
