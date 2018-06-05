class Dictionaries::Editor < ApplicationRecord

  self.table_name = 'editors'

  has_many :documents, dependent: :nullify, inverse_of: :editor

  validates :caption, presence: true, uniqueness: true

  scope :like, -> (pattern = '') { order('caption ASC').where('caption ilike ?', "%#{pattern}%") }
  scope :select_order, -> { order('lower(caption) ASC') }

  #default_scope { order('lower(caption) ASC') }

end
