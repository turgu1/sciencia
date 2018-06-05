class Comment < ApplicationRecord

  belongs_to :issue
  belongs_to :user

  default_scope { order("entry_time DESC") }

  scope :like, -> (pattern = '') { where('title ilike ?', "%#{pattern}%") }

  validates :comment, presence: true

  before_create :update_data
  after_create :update_issue

  def update_data
    self.entry_time = DateTime.now
  end

  def update_issue
    self.issue.update(last_update: self.entry_time)
  end
end
