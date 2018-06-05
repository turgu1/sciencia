class DocumentCategoriesController < ApplicationController
  #before_action :set_document_category, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:index, :create]

  # GET /document_categories
  # GET /document_categories.js
  # GET /document_categories.json
  def index
    authorize! :read, DocumentCategory

    respond_to do |format|
      format.html
      format.js
      format.json { render json: DocumentCategoriesDatatable.new(view_context) }
    end
  end

  # GET /document_categories/1
  # GET /document_categories/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /document_categories/new
  # GET /document_categories/new.js
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /document_categories/1/edit
  # GET /document_categories/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /document_categories
  # POST /document_categories.js
  def create
    @document_category = DocumentCategory.new(document_category_params)
    authorize! :create, @document_category

    respond_to do |format|
      if @document_category.save
        format.html { redirect_to @document_category, notice: "[#{@document_category.caption}] was successfully created." }
        format.js   { redirect_to @document_category, notice: "[#{@document_category.caption}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /document_categories/1
  # PATCH/PUT /document_categories/1.js
  def update
    respond_to do |format|
      if @document_category.update(document_category_params)
        format.html { redirect_to @document_category, notice: "[#{@document_category.caption}]  was successfully updated." }
        format.js   { redirect_to @document_category, notice: "[#{@document_category.caption}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /document_categories/1
  # DELETE /document_categories/1.js
    def destroy
      the_name = @document_category.caption
      @document_category.destroy
      respond_to do |format|
        format.html { redirect_to document_categories_url, notice: "[#{the_name}] was successfully deleted." }
        format.js   { redirect_to document_categories_url, notice: "[#{the_name}] was successfully deleted." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_document_category
        @document_category = DocumentCategory.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def document_category_params
        params.require(:document_category).permit(:caption, :abbreviation, :order, :rtf_header, :rtf_footer)
      end
end
