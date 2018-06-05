class DocumentSubCategory < ApplicationRecord

  has_many :peer_review_document_types,
           inverse_of: :peer_review_document_sub_category,
           class_name: 'DocumentType',
           foreign_key: 'peer_review_document_sub_category_id'

  has_many :no_peer_review_document_types,
           inverse_of: :no_peer_review_document_sub_category,
           class_name: 'DocumentType',
           foreign_key: 'no_peer_review_document_sub_category_id'

  has_many :documents, inverse_of: :document_sub_category

  belongs_to :document_category, inverse_of: :document_sub_categories

  belongs_to :translation, class_name: 'DocumentSubCategory', foreign_key: :translation_id

  validates :caption, :abbreviation, :order, :document_category_id, presence: true
  validates :order, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :caption, :abbreviation, uniqueness: true

  scope :like, -> (pattern = '') { where('caption ilike ?', "%#{pattern}%") }
  scope :sl_sub, -> () { where(sl: true).order('"order" ASC') }
  #default_scope { order('"order" ASC') }

  def full_caption
    self.abbreviation + ' - ' + self.caption
  end

  # To be used once for the transformation of documents sub categories in relation with the new
  # categorization put in place at DRDC in 2013/2014
  def self.translate_documents
    count = 0
    no_count = 0
    Document.all.includes(document_sub_category: :translation).each do |doc|
      unless doc.document_sub_category.translation.nil?
        puts "From #{doc.document_sub_category.abbreviation} to #{doc.document_sub_category.translation.abbreviation}."
        count = count + 1
        doc.update_columns(document_sub_category_id: doc.document_sub_category.translation.id)
      else
        puts "Not done..."
        no_count = no_count + 1
      end
    end
    puts "Job Completed, #{count} documents modified, #{no_count} not processed."
  end

  def abbrev
    return (abbreviation =~ /^N.+$/) ? abbreviation[1..-1] : abbreviation
  end

  def title
    return (caption =~ /\(new\) .+/) ? caption[6..-1] : caption
  end
end
