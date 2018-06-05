class AddTitleMarkerToSecurityClassifications < ActiveRecord::Migration[5.2]
  def change
  	add_column :security_classifications, :title_marker, :boolean, default: false
  end
end
