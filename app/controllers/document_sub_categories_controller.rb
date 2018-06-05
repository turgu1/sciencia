class DocumentSubCategoriesController < ApplicationController
  #before_action :set_document_sub_category, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:index, :create]

  # GET /document_sub_categories
  # GET /document_sub_categories.js
  # GET /document_sub_categories.json
  def index
    authorize! :read, DocumentSubCategory

    respond_to do |format|
      format.html
      format.js
      format.json { render json: DocumentSubCategoriesDatatable.new(view_context) }
    end
  end

  # GET /document_sub_categories/1
  # GET /document_sub_categories/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /document_sub_categories/new
  # GET /document_sub_categories/new.js
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /document_sub_categories/1/edit
  # GET /document_sub_categories/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /document_sub_categories
  # POST /document_sub_categories.js
  def create
    @document_sub_category = DocumentSubCategory.new(document_sub_category_params)
    authorize! :create, @document_sub_category

    respond_to do |format|
      if @document_sub_category.save
        format.html { redirect_to @document_sub_category, notice: "[#{@document_sub_category.caption}] was successfully created." }
        format.js   { redirect_to @document_sub_category, notice: "[#{@document_sub_category.caption}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /document_sub_categories/1
  # PATCH/PUT /document_sub_categories/1.js
  def update
    respond_to do |format|
      if @document_sub_category.update(document_sub_category_params)
        format.html { redirect_to @document_sub_category, notice: "[#{@document_sub_category.caption}]  was successfully updated." }
        format.js   { redirect_to @document_sub_category, notice: "[#{@document_sub_category.caption}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /document_sub_categories/1
  # DELETE /document_sub_categories/1.js
    def destroy
      the_name = @document_sub_category.caption
      @document_sub_category.destroy
      respond_to do |format|
        format.html { redirect_to document_sub_categories_url, notice: "[#{the_name}] was successfully deleted." }
        format.js   { redirect_to document_sub_categories_url, notice: "[#{the_name}] was successfully deleted." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_document_sub_category
        @document_sub_category = DocumentSubCategory.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def document_sub_category_params
        params.require(:document_sub_category).permit(
          :caption, :abbreviation, :order, :translation_id, :document_category_id, :peer_review_required, :sl)
      end
end
