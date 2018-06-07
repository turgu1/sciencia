# This class is expected to be specialized for each dictionary models
# The specialized class must initialize the @model attribute to point
# to the appropriate model class.

class Dictionaries::BaseDatatable
  delegate :all_actions, :edit_action, :delete_action, :replace_action, :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @model.count,
      iTotalDisplayRecords: items.total_count,
      aaData: data
    }
  end

  private

    def data
      items.map do |item|
        {
          'DT_RowId': "DICT_#{item.id}",
          '0': item.caption,
          '1': [all_actions(item, item.caption), replace_action(item)].join(' ').html_safe
        }
      end
    end

    def items
      @items ||= fetch_items
    end

    def fetch_items
      my_items = @model
          .order("#{sort_column} #{sort_direction}")
          .page(page).per(per_page)
      if params[:sSearch].present?
        my_items = my_items.like("#{params[:sSearch]}")
      end
      my_items
    end

    def page
      params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def sort_column
      columns = %w[caption]
      columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end
end