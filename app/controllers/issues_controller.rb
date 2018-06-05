class IssuesController < ApplicationController
  #before_action :set_issue, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:index, :create]

  def state_change
    if (params[:state] == 'Open') || (params[:state] == 'Close')
      @issue.update(state: params[:state])
    end
    respond_to do |format|
      format.html { redirect_to @issue, notice: "[#{@issue.title}] state was successfully updated." }
      format.js   { redirect_to @issue, notice: "[#{@issue.title}] state was successfully updated." }
    end
  end

  # GET /issues
  # GET /issues.js
  # GET /issues.json
  def index
    authorize! :read, Issue

    respond_to do |format|
      format.html
      format.js
      format.json { render json: IssuesDatatable.new(view_context) }
    end
  end

  # GET /issues/1
  # GET /issues/1.js
  def show
    if params[:modal]
      render action: :show_modal
    else
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  # GET /issues/new
  # GET /issues/new.js
  def new
    @issue.state = 'Open'
    @issue.issue_type = 'Malfunction'
    @issue.comments.build

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /issues/1/edit
  # GET /issues/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /issues
  # POST /issues.js
  def create
    @issue = Issue.new(issue_params)
    @issue.user = current_user
    @issue.comments[0].user = current_user

    authorize! :create, @issue

    respond_to do |format|
      if @issue.save
        format.html { redirect_to @issue, notice: "[#{@issue.title}] was successfully created." }
        format.js   { redirect_to @issue, notice: "[#{@issue.title}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.js
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        format.html { redirect_to @issue, notice: "[#{@issue.title}]  was successfully updated." }
        format.js   { redirect_to @issue, notice: "[#{@issue.title}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.js
    def destroy
      the_name = @issue.title
      @the_id = @issue.id
      @issue.destroy
      respond_to do |format|
        format.html { flash[:notice] = "[#{the_name}] was successfully deleted." }
        format.js   { flash[:notice] = "[#{the_name}] was successfully deleted." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_issue
        @issue = Issue.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def issue_params
        params.require(:issue).permit(
            :title, :state, :issue_type, :user_id, :last_update,
            comments_attributes: [:id, :comment, :user_id, :issue_id, :_destroy])
      end
end
