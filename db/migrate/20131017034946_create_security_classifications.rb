class CreateSecurityClassifications < ActiveRecord::Migration[5.2]
  def change
    create_table :security_classifications do |t|
      t.string :caption
      t.string :abbreviation
      t.integer :order

      t.timestamps
    end
  end
end
