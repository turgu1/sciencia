class SecurityClassificationsDatatable < BaseDatatable

  def initialize(view)
    @model = SecurityClassification
    super(view)
  end

  private

    def data
      items.map do |item|
        [
            item.caption,
            item.abbreviation,
            item.title_marker ? 'Yes' : '',
            item.order,
            all_actions(item, item.caption)
        ]
      end
    end

    def sort_column
      columns = %w["caption" "abbreviation" "title_marker" "order"]
      columns[params[:iSortCol_0].to_i]
    end
end
