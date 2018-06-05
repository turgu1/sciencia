class DocumentSubCategoriesDatatable < BaseDatatable

  def initialize(view)
    @model = DocumentSubCategory
    super(view)
  end

  private

    def data
      items.map do |item|
        [
          item.caption,
          item.abbreviation,
          item.order,
          item.document_category.abbreviation,
          item.peer_review_required ? 'Yes' : '',
          item.sl ? 'Yes' : '',
          item.translation.try(:caption) || '',
          all_actions(item, item.caption)
        ]
      end
    end

    def sort_column
      columns = %w[ "caption" "abbreviation" "order" _ "peer_review_required" "sl" _ _]
      columns[params[:iSortCol_0].to_i]
    end
end
