class PeerReview < ApplicationRecord

  has_many :documents, dependent: :nullify, inverse_of: :peer_review

  validates :caption, :abbreviation, :order, presence: true
  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :caption, :abbreviation, uniqueness: true

  scope :like, -> (pattern = '') { where('caption ilike :pat', pat: "%#{pattern}%") }
  scope :select_order, -> { order('"order" ASC', 'caption ASC') }
  #default_scope { order('"order" ASC', 'caption ASC') }

  def full_caption
    self.abbreviation + ' - ' + self.caption
  end
end
