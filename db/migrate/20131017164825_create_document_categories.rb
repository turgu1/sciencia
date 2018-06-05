class CreateDocumentCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :document_categories do |t|
      t.string :caption
      t.string :abbreviation
      t.integer :order
      t.text :rtf_header
      t.text :rtf_footer

      t.timestamps
    end
  end
end
