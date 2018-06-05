class AddUserToPerson < ActiveRecord::Migration[5.2]
  def change
    add_reference :people, :user, index: true
  end
end
