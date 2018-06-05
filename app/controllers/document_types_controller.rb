class DocumentTypesController < ApplicationController
  #before_action :set_document_type, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:index, :change, :create]

  def change
    authorize! :read, DocumentType

    @document_type = DocumentType.find(params[:document_type_id])
    #@document.id = params[:id].to_i
    #@document.attributes = params[:document].reject { |_,v| v.blank? }

    respond_to do |format|
      format.js
    end
  end

  # GET /document_types
  # GET /document_types.js
  # GET /document_types.json
  def index
    authorize! :read, DocumentType

    respond_to do |format|
      format.html
      format.js
      format.json { render json: DocumentTypesDatatable.new(view_context) }
    end
  end

  # GET /document_types/1
  # GET /document_types/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /document_types/new
  # GET /document_types/new.js
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /document_types/1/edit
  # GET /document_types/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /document_types
  # POST /document_types.js
  def create
    @document_type = DocumentType.new(document_type_params)
    authorize! :create, @document_type

    respond_to do |format|
      if @document_type.save
        format.html { redirect_to @document_type, notice: "[#{@document_type.caption}] was successfully created." }
        format.js   { redirect_to @document_type, notice: "[#{@document_type.caption}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /document_types/1
  # PATCH/PUT /document_types/1.js
  def update
    respond_to do |format|
      if @document_type.update(document_type_params)
        format.html { redirect_to @document_type, notice: "[#{@document_type.caption}]  was successfully updated." }
        format.js   { redirect_to @document_type, notice: "[#{@document_type.caption}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /document_types/1
  # DELETE /document_types/1.js
    def destroy
      the_name = @document_type.caption
      @document_type.destroy
      respond_to do |format|
        format.html { redirect_to document_types_url, notice: "[#{the_name}] was successfully deleted." }
        format.js   { redirect_to document_types_url, notice: "[#{the_name}] was successfully deleted." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_document_type
        @document_type = DocumentType.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def document_type_params
        params.require(:document_type).permit(
          :caption, :abbreviation, :order, :synonyms, :field_list, :report_field_list, :hidden_author,
          :peer_review_document_sub_category_id, :no_peer_review_document_sub_category_id)
      end
end
