class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :document_reference
      t.references :security_classification, index: true
      t.references :peer_review, index: true
      t.string :page_count
      t.string :pages_reference
      t.references :document_type, index: true
      t.string :address
      t.text :annote
      t.string :booktitle
      t.string :chapter
      t.string :edition
      t.references :editor, index: true
      t.string :howpublished
      t.references :institution, index: true
      t.string :key
      t.integer :month
      t.text :note
      t.integer :number
      t.references :org, index: true
      t.references :publisher, index: true
      t.references :school, index: true
      t.string :series
      t.integer :volume
      t.integer :year
      t.text :abstract
      t.text :contents
      t.string :copyright
      t.string :isbn
      t.string :issn
      t.string :keywords
      t.references :language, index: true
      t.string :location
      t.string :lccn
      t.string :url
      t.references :document_sub_category, index: true
      t.references :journal, index: true
      t.references :last_update_by, index: true

      t.timestamps
    end
  end
end
