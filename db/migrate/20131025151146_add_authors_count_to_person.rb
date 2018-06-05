class AddAuthorsCountToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :authors_count, :integer, default: 0
  end
end
