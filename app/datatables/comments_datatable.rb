class CommentsDatatable < BaseDatatable

  def initialize(view)
    @model = Comment
    super(view)
  end

  private

    def data
      items.map do |item|
        {
            '0' => item.comment,
            '1' => item.user.try(:username) || 'Unknown',
            '2' => item.entry_time.getlocal.strftime('%F %T'),
            '3' => all_actions(item, item.comment)
        }
      end
    end

    def sort_column
      columns = %w[ "comment" "user" "entry_time" "issue"]
      columns[params[:iSortCol_0].to_i]
    end
end
