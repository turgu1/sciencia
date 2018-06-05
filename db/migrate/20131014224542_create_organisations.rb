class CreateOrganisations < ActiveRecord::Migration[5.2]
  def change
    create_table :organisations do |t|
      t.string :name
      t.string :abbreviation
      t.integer :people_count, default: 0
      t.boolean :other, default: false
      t.integer :order

      t.timestamps
    end
  end
end
