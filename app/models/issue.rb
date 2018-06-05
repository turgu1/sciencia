class Issue < ApplicationRecord

  has_many :comments, inverse_of: :issue, dependent: :destroy
  belongs_to :user

  before_save :adjust_data

  validates :title, :state, :issue_type, presence: true
  accepts_nested_attributes_for :comments, allow_destroy: true

  scope :like,  -> (pattern = '') { where('title ilike :pat', pat: "%#{pattern}%") }
  scope :open,  -> () { where(state: 'Open' ) }
  scope :close, -> () { where(state: 'Close') }

  default_scope { order("last_update DESC") }

  def self.issue_types
    ['Malfunction', 'Help', 'Idea']
  end

  def self.states
    ['Open', 'Close']
  end

  private
    def adjust_data
      self.last_update = DateTime.now
    end
end
