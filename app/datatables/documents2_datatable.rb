class Documents2Datatable < BaseDatatable

  delegate :check_box_tag, :author_list, to: :@view

  def initialize(view, parent)
    @model = Document
    @parent = parent
    super(view)
  end

  private

    def data
      items.map do |item|
        {
          '0': item.document_type.try(:abbreviation) || 'NONE!!!',
          '1': item.document_sub_category.try(:abbreviation) || 'NONE!!!',
          '2': item.document_reference.html_safe,
          '3': item.title,
          '4': author_list(item, :html2),
          '5': item.date,
        }
      end
    end

    def doc_sort_direction(col)
      params["sSortDir_#{col}".to_sym] == "desc" ? "DESC" : "ASC"
    end

    def doc_sort_column(col)
      col_idx = "iSortCol_#{col}".to_sym

      [
        'document_types.abbreviation',
        'document_sub_categories.abbreviation',
        :document_reference,
        :title,
        nil,
        :date
      ][params[col_idx].to_i]
    end

    def doc_sort_reference(col)
      col_idx = "iSortCol_#{col}".to_sym
      [
          :document_type,
          :document_sub_category,
          nil,
          nil,
          nil,
          nil
      ][params[col_idx].to_i]
    end

    def fetch_items

      col_count = params[:iSortingCols].to_i

      sort_data = (0..(col_count - 1)).map { |col|
        field = doc_sort_column(col)
        dir   = doc_sort_direction(col).to_s

        if field == :date
          "documents.year #{dir},documents.month #{dir}"
        elsif field
          "#{field.to_s} #{dir}"
        else
          nil
        end
      }.compact.join(',')
      refs = (0..(col_count - 1)).map { |col| doc_sort_reference(col) }.compact

      my_items = @parent.documents

      my_items = my_items.left_outer_joins(*refs) unless refs.blank?
      my_items = my_items.reorder(sort_data) unless sort_data.blank?

      # Rails.logger.debug "====> SORT DATA: #{sort_data}"
      # Rails.logger.debug "====> SORT REFS: #{refs.inspect}"

      my_items = my_items.page(page).per(per_page)
      my_items = my_items.like("#{params[:sSearch]}") if params[:sSearch].present?

      #puts "====> RESULT: #{my_items[0].inspect}"
      my_items
    end
end
