class DocumentType < ApplicationRecord

  has_many :documents, inverse_of: :document_type

  belongs_to :peer_review_document_sub_category,
             inverse_of: :peer_review_document_types,
             class_name: 'DocumentSubCategory',
             foreign_key: "peer_review_document_sub_category_id"

  belongs_to :no_peer_review_document_sub_category,
             inverse_of: :no_peer_review_document_types,
             class_name: 'DocumentSubCategory',
             foreign_key: "no_peer_review_document_sub_category_id"

  validates :caption, :abbreviation, :order,
            :peer_review_document_sub_category_id,
            :no_peer_review_document_sub_category_id,
            presence: true
  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :caption, :abbreviation, uniqueness: true

  scope :like, -> (pattern = '') { where('caption ilike ?', "%#{pattern}%") }
  #default_scope { order('"order" ASC') }

  def full_caption
    self.abbreviation + ' - ' + self.caption
  end

  def fields_sym_list
    self.field_list.nil? ? [] : self.field_list.split.collect { |element| eval(element).to_sym }
  end

  def fields_list
    self.field_list.nil? ? [] : self.field_list.split.collect { |element| eval(element).to_s }
  end

  def report_fields_list
    self.report_field_list.nil? ? [] : self.report_field_list.split.collect { |element| eval(element).to_s }
  end
end
