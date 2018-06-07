class DocumentsController < ApplicationController
  before_action :set_parent, only: [:index, :edit, :new, :update, :create, :destroy, :show_and_return]
  #before_action :set_document, only: [:show, :edit, :update, :destroy, :show_and_return]
  load_and_authorize_resource except: [:index, :new, :create]

  def check_duplicate
    if params[:title]
      @documents = Document.where(title: params[:title])
      doc_id     = params[:doc_id] ? params[:doc_id].to_id : nil
      @documents = @documents.select { |d| d.id != doc_id } if doc_id
      if @documents.size > 0
        @msg = "There is some similar title in the database!"
      end
    end
  end

  # GET /documents
  # GET /documents.js
  # GET /documents.json
  def index
    authorize! :read, Document

    respond_to do |format|
      format.html
      format.js
      format.json { render json: params[:modal] ? Documents2Datatable.new(view_context, @parent) : DocumentsDatatable.new(view_context, @parent) }
    end
  end

  # GET /documents/1
  # GET /documents/1.js
  def show_and_return
    @return_path = url_for(
        controller: @parent.class.name.underscore.pluralize,
        action:    :show,
        id:         @parent.id)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /documents/1
  # GET /documents/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /documents/new
  # GET /documents/new.js
  def new
    dt = DocumentType.where(abbreviation: 'R').take

    @document = Document.new({
        month:        Time.now.month,
        year:         Time.now.year,
        peer_review:  PeerReview.find(2),
        publisher:    Dictionaries::Publisher.where(caption: 'DRDC-RDDC').take,
        document_sub_category:  DocumentSubCategory.find(dt.peer_review_document_sub_category_id),
        document_type:  dt
    })

    @document.authors.build({
        person_id:    current_user.person_id,
        main_author:  true,
        hidden:       false,
        order:        1
    })
    authorize! :create, @document

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /documents/1/edit
  # GET /documents/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /documents
  # POST /documents.js
  def create
    @document = Document.new(document_params)
    @document.adjustments_before_save(current_user)
    authorize! :create, @document

    respond_to do |format|
      if @document.save
        path = url_for(
            controller:  :documents,
            action:      :show_and_return,
            id:           @document.id,
            parent_klass: @parent.class.name,
            parent_id:    @parent.id)
        notice =  "[#{@document.title}] was successfully created."
        format.html { redirect_to path, notice: notice }
        format.js   { redirect_to path, notice: notice }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.js
  def update
    @document.assign_attributes(document_params)
    @document.adjustments_before_save(current_user)

    authorize! :update, @document

    respond_to do |format|
      if @document.save
        path = url_for(
            controller:  :documents,
            action:      :show_and_return,
            id:           @document.id,
            parent_klass: @parent.class.name,
            parent_id:    @parent.id)
        notice = "[#{@document.title}]  was successfully updated."
        format.html { redirect_to path, notice: notice }
        format.js   { redirect_to path, notice: notice }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.js
    def destroy
      @the_name = @document.title
      @the_id = @document.id
      @document.destroy
      notice = "[#{@the_name}] was successfully deleted."
      respond_to do |format|
        format.html { flash[:notice] = notice }
        format.js   { flash[:notice] = notice }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.

      def set_parent
        klass = params[:parent_klass]
        #klass = klass[:value] if klass.is_a?(Hash)
        klass_id = params[:parent_id]
        #klass_id = klass_id[:value] if klass.is_a?(Hash)
        @parent = klass.constantize.find(klass_id.to_i)
      end

      def set_document
        @document = Document.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def document_params
        params.require(:document).permit(
          :title,     :document_reference, :booktitle, :page_count,  :address, :lccn, :contents,
          :annote,    :pages_reference,    :abstract,  :edition,     :key,     :month,
          :chapter,   :howpublished,       :location,  :note,        :series,  :year, 
          :copyright, :keywords,           :number,    :volume,      :isbn,    :issn, :url,
          :document_sub_category_id,   :document_type_id,  :peer_review_id,
          :security_classification_id, :editor_caption,    :institution_caption,
          :org_caption,                :publisher_caption, :school_caption,
          :journal_caption,            :language_caption,
          last_update_by:         [:id],
          authors_attributes:     [:id, :name, :main_author, :order, :hidden, :_destroy],
          events_attributes:      [:id, :description, :author_id, :year, :month, :_destroy],
          attachments_attributes: [:id, :doc_file, :_destroy]
        )
      end
end
