class EventsDatatable < BaseDatatable

  def initialize(view)
    @model = Event
    super(view)
  end

  private

    def data
      items.map do |item|
        [
            item.description,
            item.month,
            item.year,
            item.author,
            item.document,
            all_actions(item, item.description)
        ]
      end
    end

    def sort_column
      columns = %w[ "description" "month" "year" "author" "document"]
      columns[params[:iSortCol_0].to_i]
    end
end
