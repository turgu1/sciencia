class PeopleDatatable < BaseDatatable

  def initialize(view, organisation)
    @model = Person
    @organisation = organisation
    super(view)
  end

  private

    def data
      items.map do |item|
        {
            'DT_RowId' => "PERSON_#{item.id}",
            '0' => item.last_name,
            '1' => item.first_name,
            '2' => item.email,
            '3' => item.phone,
            '4' => item.authors_count,
            '5' => [all_actions(item, item.complete_name_with_org), move_action(item), replace_action(item)].compact.join(' ')
        }
      end
    end

    def sort_column
      columns = %w[ last_name first_name email phone authors_count _]
      columns[params[:iSortCol_0].to_i]
    end

    def fetch_items
      my_items = @organisation.people
        .order("#{sort_column} #{sort_direction}")
        .page(page).per(per_page)
      if params[:sSearch].present?
        my_items = my_items.like("#{params[:sSearch]}")
      end
      my_items
    end
end
