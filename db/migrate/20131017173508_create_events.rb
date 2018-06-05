class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :description
      t.integer :month
      t.integer :year
      t.references :author,   index: true
      t.references :document, index: true

      t.timestamps
    end
  end
end
