class CreateIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :issues do |t|

      t.string     :title
      t.string     :state
      t.string     :issue_type
      t.references :user, index: true
      t.datetime   :last_update

      t.timestamps
    end
  end
end
