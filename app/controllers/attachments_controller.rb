class AttachmentsController < ApplicationController
  load_and_authorize_resource except: [:index, :create, :download]

  def download
    @attachment = Attachment.find(params[:id])
    authorize! :read, @attachment

    send_file(@attachment.doc_file.current_path)
  end

  # GET /attachments
  # GET /attachments.js
  # GET /attachments.json
  def index
    authorize! :read, Attachment
    respond_to do |format|
      format.html
      format.js
      format.json { render json: AttachmentsDatatable.new(view_context) }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /attachments/new
  # GET /attachments/new.js
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /attachments/1/edit
  # GET /attachments/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /attachments
  # POST /attachments.js
  def create
    @attachment = Attachment.new(attachment_params)
    authorize! :create, @attachment

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: "[#{@attachment.document}] was successfully created." }
        format.js   { redirect_to @attachment, notice: "[#{@attachment.document}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.js
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment, notice: "[#{@attachment.document}]  was successfully updated." }
        format.js   { redirect_to @attachment, notice: "[#{@attachment.document}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.js
    def destroy
      the_name = @attachment.document
      @attachment.destroy
      respond_to do |format|
        format.html { redirect_to attachments_url, notice: "[#{the_name}] was successfully deleted." }
        format.js   { redirect_to attachments_url, notice: "[#{the_name}] was successfully deleted." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_attachment
        @attachment = Attachment.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def attachment_params
        params.require(:attachment).permit(:document_id, :content_type, :filename, :thumbnail, :size, :width, :height, :erased)
      end
end
