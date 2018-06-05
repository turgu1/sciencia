class SecurityClassificationsController < ApplicationController
  #before_action :set_security_classification, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:index, :create]

  # GET /security_classifications
  # GET /security_classifications.js
  # GET /security_classifications.json
  def index
    authorize! :read, SecurityClassification
    respond_to do |format|
      format.html
      format.js
      format.json { render json: SecurityClassificationsDatatable.new(view_context) }
    end
  end

  # GET /security_classifications/1
  # GET /security_classifications/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /security_classifications/new
  # GET /security_classifications/new.js
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /security_classifications/1/edit
  # GET /security_classifications/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /security_classifications
  # POST /security_classifications.js
  def create
    @security_classification = SecurityClassification.new(security_classification_params)
    authorize! :create, @security_classification

    respond_to do |format|
      if @security_classification.save
        format.html { redirect_to @security_classification, notice: "[#{@security_classification.caption}] was successfully created." }
        format.js   { redirect_to @security_classification, notice: "[#{@security_classification.caption}] was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /security_classifications/1
  # PATCH/PUT /security_classifications/1.js
  def update
    respond_to do |format|
      if @security_classification.update(security_classification_params)
        format.html { redirect_to @security_classification, notice: "[#{@security_classification.caption}] was successfully updated." }
        format.js   { redirect_to @security_classification, notice: "[#{@security_classification.caption}] was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /security_classifications/1
  # DELETE /security_classifications/1.js
  def destroy
    caption = @security_classification.caption
    @security_classification.destroy
    respond_to do |format|
      format.html { redirect_to security_classifications_url, notice: "[#{caption}] was successfully deleted." }
      format.js   { redirect_to security_classifications_url, notice: "[#{caption}] was successfully deleted." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_security_classification
      @security_classification = SecurityClassification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def security_classification_params
      params.require(:security_classification).permit(:caption, :abbreviation, :order, :title_marker)
    end
end
