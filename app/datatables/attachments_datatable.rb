class AttachmentsDatatable < BaseDatatable

  def initialize(view)
    @model = Attachment
    super(view)
  end

  private

    def data
      items.map do |item|
        [
            item.doc_file,
            item.date_time,
            destroy_action(item, item.document)
        ]
      end
    end

    def sort_column
      columns = %w[ "doc_file" "created_at" ]
      columns[params[:iSortCol_0].to_i]
    end
end
