class AddHiddenAuthorToDocumentType < ActiveRecord::Migration[5.2]
  def change
    add_column :document_types, :hidden_author, :boolean
  end
end
