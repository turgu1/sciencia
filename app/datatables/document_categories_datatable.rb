class DocumentCategoriesDatatable < BaseDatatable

  def initialize(view)
    @model = DocumentCategory
    super(view)
  end

  private

    def data
      items.map do |item|
        [
            item.caption,
            item.abbreviation,
            item.order,
            all_actions(item, item.caption)
        ]
      end
    end

    def sort_column
      columns = %w[ "caption" "abbreviation" "order" ]
      columns[params[:iSortCol_0].to_i]
    end
end
