class Attachment < ApplicationRecord
  belongs_to :document, inverse_of: :attachments

  validates :doc_file, presence: true

  default_scope { order(created_at: :asc) }

  mount_uploader :doc_file, DocFileUploader

  def date_time
    self.created_at.getlocal.strftime('%F %T')
  end

end
