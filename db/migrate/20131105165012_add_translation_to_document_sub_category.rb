class AddTranslationToDocumentSubCategory < ActiveRecord::Migration[5.2]
  def change
    add_reference :document_sub_categories, :translation, index: true
  end
end
