class CreateDocumentTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :document_types do |t|
      t.string :caption
      t.string :abbreviation
      t.integer :order
      t.string :synonyms
      t.string :field_list
      t.string :report_field_list
      t.integer :peer_review_document_sub_category_id, index: true
      t.integer :no_peer_review_document_sub_category_id, index: true

      t.timestamps
    end
  end
end
