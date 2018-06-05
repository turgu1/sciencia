class OrganisationsDatatable < BaseDatatable

  def initialize(view)
    @model = Organisation
    super(view)
  end

  private

    def data
      items.map do |item|
        [
          item.name,
          item.abbreviation,
          item.people_count,
          item.other ? 'Yes' : '',
          item.order,
          [all_actions(item, item.name), replace_action(item)].compact.join(' ')
        ]
      end
    end

    def sort_column
      columns = %w[name abbreviation people_count other "order"]
      columns[params[:iSortCol_0].to_i]
    end
end
