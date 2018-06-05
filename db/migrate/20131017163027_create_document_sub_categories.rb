class CreateDocumentSubCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :document_sub_categories do |t|
      t.string :caption
      t.string :abbreviation
      t.integer :order
      t.references :document_category, index: true
      t.boolean :peer_review_required
      t.boolean :sl

      t.timestamps
    end
  end
end
