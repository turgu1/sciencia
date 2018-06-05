class ModifyAttachments < ActiveRecord::Migration[5.2]
  def change
    remove_column :attachments, :content_type, :string
    remove_column :attachments, :filename,     :string
    remove_column :attachments, :thumbnail,    :string
    remove_column :attachments, :size,         :integer
    remove_column :attachments, :width,        :integer
    remove_column :attachments, :height,       :integer
    remove_column :attachments, :erased,       :boolean

    add_column :attachments, :doc_file, :string
  end
end
