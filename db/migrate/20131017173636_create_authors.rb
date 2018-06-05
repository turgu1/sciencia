class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors do |t|
      t.references :person,   index: true
      t.references :document, index: true
      t.boolean :main_author, default: true
      t.boolean :hidden,      default: false
      t.integer :order

      t.timestamps
    end
  end
end
