class SecurityClassification < ApplicationRecord

  has_many :documents, dependent: :nullify, inverse_of: :security_classification

  validates :caption, :abbreviation, :order, presence: true
  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :caption, :abbreviation, uniqueness: true

  scope :like, -> (pattern = '') { where('caption ilike :pat', pat: "%#{pattern}%") }
  scope :select_order, -> { order('"order" ASC', 'caption ASC') }

  def full_caption
    self.abbreviation + ' - ' + self.caption
  end
end
