class CreatePublishers < ActiveRecord::Migration[5.2]
  def change
    create_table :publishers do |t|
      t.string :caption

      # Todo: Will need to cleanup these following 2 fields
      t.string :reference_prefix
      t.boolean :is_a_reference_prefix

      t.timestamps
    end
  end
end
