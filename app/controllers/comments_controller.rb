class CommentsController < ApplicationController
  before_action :set_issue, only: [:index, :new, :create]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.js
  # GET /comments.json
  def index
    respond_to do |format|
      format.html
      format.js
      format.json { render json: CommentsDatatable.new(view_context) }
    end
  end

  # GET /comments/1
  # GET /comments/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /comments/new
  # GET /comments/new.js
  def new
    @comment = @issue.comments.build
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /comments/1/edit
  # GET /comments/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /comments
  # POST /comments.js
  def create
    @comment = @issue.comments.build(comment_params)
    @comment.user = current_user
    @comment.entry_time = DateTime.now

    respond_to do |format|
      if @comment.save
        @issue = @comment.issue
        format.html { flash[:notice] = "[#{strip_tags(@comment.comment)[0..15]}...] was successfully created." }
        format.js   { flash[:notice] = "[#{strip_tags(@comment.comment)[0..15]}...]  was successfully created." }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.js
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        @issue = @comment.issue
        format.html { flash[:notice] = "[#{strip_tags(@comment.comment)[0..15]}...]  was successfully updated." }
        format.js   { flash[:notice] = "[#{strip_tags(@comment.comment)[0..15]}...]  was successfully updated." }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.js
    def destroy
      the_name = @comment.comment
      @issue = @comment.issue
      @comment.destroy
      respond_to do |format|
        format.html { flash[:notice] = "[#{strip_tags(@comment.comment)[0..15]}...] was successfully deleted." }
        format.js   { flash[:notice] = "[#{strip_tags(@comment.comment)[0..15]}...] was successfully deleted." }
      end
    end

    private

      def strip_tags(str)
        str.gsub(/<[^<]*>/, '').gsub('&nbsp;', ' ')
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_issue
        @issue = Issue.find(params[:issue_id])
      end

      def set_comment
        @comment = Comment.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def comment_params
        params.require(:comment).permit(:comment, :user_id, :entry_time, :issue_id)
      end
end
