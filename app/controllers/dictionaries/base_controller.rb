class Dictionaries::BaseController < ApplicationController
  before_action :set_model
  before_action :set_dictionaries_item, only: [:show, :edit, :update, :destroy]

  # GET /dictionaries/languages/1/replace.js
  def replace
    authorize! :manage, @model

    @old         = @model.find(params[:id])
    @return_path = url_for(controller: controller_name, action: :index)
    @exec_path   = url_for(controller: controller_name, action: :replace_with)
  end

  # POST /dictionaries/languages/replace_with.js
  def replace_with
    authorize! :manage, @model

    flash[:notice] = Document.do_replace(
        @model,
        params[:replacement][:old_id],
        params[:replacement][:new_id],
        params[:replacement][:delete_after] == '1')

    redirect_to url_for(controller: controller_name, action: :index)
  end

  # GET /dictionaries/languages
  # GET /dictionaries/languages.json?q=search
  # GET /dictionaries/languages.js
  # GET /dictionaries/languages.json
  def index
    authorize! :read, @model

    if params[:q]
      @items = @model.like(params[:q])
      respond_to do |format|
        format.json   {
          @data = { captions: @items.map { |p| p.caption } }
          render json: @data
        }
      end
    else
      respond_to do |format|
        format.html
        format.js
        format.json { render json: @datatable.new(view_context) }
      end
    end

  end

  # GET /dictionaries/languages/1
  # GET /dictionaries/languages/1.js
  def show
    authorize! :read, @item
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /dictionaries/languages/new
  # GET /dictionaries/languages/new.js
  def new
    @item = @model.new
    authorize! :create, @item

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /dictionaries/languages/1/edit
  # GET /dictionaries/languages/1/edit.js
  def edit
    authorize! :update, @item
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /dictionaries/languages
  # POST /dictionaries/languages.js
  def create
    @item = @model.new(dictionaries_item_params)
    authorize! :create, @item

    respond_to do |format|
      if @item.save
        format.html { redirect_to url_for(controller: controller_name, action: :index), notice: "[#{@item.caption}] was successfully created." }
        format.js   { redirect_to url_for(controller: controller_name, action: :index), notice: "[#{@item.caption}] was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /dictionaries/languages/1
  # PATCH/PUT /dictionaries/languages/1.js
  def update
    authorize! :update, @item
    respond_to do |format|
      if @item.update(dictionaries_item_params)
        format.html { redirect_to url_for(controller: controller_name, action: :index), notice: "[#{@item.caption}] was successfully updated." }
        format.js   { redirect_to url_for(controller: controller_name, action: :index), notice: "[#{@item.caption}] was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /dictionaries/languages/1
  # DELETE /dictionaries/languages/1.js
  def destroy
    authorize! :destroy, @item

    @the_id = @item.id
    @the_caption = @item.caption
    @item.destroy

    respond_to do |format|
      format.html { flash[:notice] = "[#{@the_caption}] was successfully deleted." }
      format.js   { flash[:notice] = "[#{@the_caption}] was successfully deleted." }
    end
  end

  private

    def set_model
      @model_name = controller_name.classify
      @model = "Dictionaries::#{@model_name}".constantize
      @datatable = "Dictionaries::#{@model_name.pluralize}Datatable".constantize
      @model_symbol = "dictionaries_#{controller_name.singularize}".to_sym
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_dictionaries_item
      @item = @model.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dictionaries_item_params
      params.require(@model_symbol).permit(:caption)
    end
end
