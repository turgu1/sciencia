class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :comment
      t.datetime :entry_time
      t.references :user, index: true
      t.references :issue, index: true

      t.timestamps
    end
  end
end
