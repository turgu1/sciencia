class DocumentCategory < ApplicationRecord

  has_many :document_sub_categories, inverse_of: :document_category

  validates :caption, :abbreviation, :order, presence: true
  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :caption, :abbreviation, uniqueness: true

  scope :like, -> (pattern = '') { where('caption ilike :pat', pat: "%#{pattern}%") }
  scope :docs_for_list, -> (person) {
    includes(:document_sub_categories => { :documents => [{:authors => :person }, {:events => {:author => :person}}]}).
    order('document_categories.order ASC, document_sub_categories.order ASC, documents.year DESC, documents.month DESC, events.description ASC, events.year DESC, events.month DESC').
    where("documents.id in (:docs)", docs: person.documents.collect(&:id)).
    references(:documents) }

  #default_scope { order('"order" ASC') }

  def full_caption
    self.abbreviation + ' - ' + self.caption
  end
end
