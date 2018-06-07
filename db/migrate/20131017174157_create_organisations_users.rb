class CreateOrganisationsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :organisations_users, id: false do |t|
      t.references :organisation, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
