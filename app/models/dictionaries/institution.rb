class Dictionaries::Institution < ApplicationRecord

  self.table_name = 'institutions'

  has_many :documents, dependent: :nullify, inverse_of: :institution

  validates :caption, presence: true, uniqueness: true

  scope :like, -> (pattern = '') { order('caption ASC').where('caption ilike ?', "%#{pattern}%") }
  scope :select_order, -> { order('lower(caption) ASC') }

  #default_scope { order('lower(caption) ASC') }

end
