class AuthorsDatatable < BaseDatatable

  def initialize(view, document)
    @model = Author
    @document = document
    super(view)
  end

  private

    def data
      items.map do |item|
        [
            item.person,
            item.main_author ? 'Yes' : '',
            item.hidden ? 'Yes' : '',
            item.order,
            all_actions(item, item.person)
        ]
      end
    end

    def sort_column
      columns = %w[ "person" "main_author" "hidden" "order" ]
      columns[params[:iSortCol_0].to_i]
    end

    def fetch_items
      my_items = @document.authors
        .order("#{sort_column} #{sort_direction}")
        .page(page).per(per_page)
      if params[:sSearch].present?
        my_items = my_items.like("#{params[:sSearch]}")
      end
      my_items
    end

end
