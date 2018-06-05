class DocumentTypesDatatable < BaseDatatable

  def initialize(view)
    @model = DocumentType
    super(view)
  end

  private

    def data
      items.map do |item|
        [
            item.caption,
            item.abbreviation,
            item.order,
            item.peer_review_document_sub_category.abbreviation,
            item.no_peer_review_document_sub_category.abbreviation,
            all_actions(item, item.caption)
        ]
      end
    end

    def sort_column
      columns = %w[ "caption" "abbreviation" "order" "peer_review_document_sub_category" "no_peer_review_document_sub_category"]
      columns[params[:iSortCol_0].to_i]
    end
end
