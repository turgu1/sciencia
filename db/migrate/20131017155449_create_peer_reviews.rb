class CreatePeerReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :peer_reviews do |t|
      t.string :caption
      t.string :abbreviation
      t.integer :order

      t.timestamps
    end
  end
end
