class IssuesDatatable < BaseDatatable

  def initialize(view)
    @model = Issue
    super(view)
  end

  private

    def data
      items.map do |item|
        {
            'DT_RowId' => "ISSUE_#{item.id}",
            '0' => item.title,
            '1' => item.state,
            '2' => item.issue_type,
            '3' => item.user.try(:username) || 'Unknown!!!',
            '4' => item.last_update.getlocal.strftime('%F %T'),
            '5' => all_actions(item, item.title)
        }
      end
    end

    def sort_column
      columns = %w[title state issue_type user last_update]
      columns[params[:iSortCol_0].to_i]
    end

    def fetch_items
      my_items = @model
        .order("#{sort_column} #{sort_direction}")
        .page(page).per(per_page)
      my_items = my_items.where(state: params[:state]) if params[:state]
      my_items = my_items.like("#{params[:sSearch]}") if params[:sSearch].present?
      my_items
    end

end
