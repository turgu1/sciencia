class AuthorsController < ApplicationController
  before_action :set_document, only: [:index, :new, :create]
  load_and_authorize_resource except: [:index, :new, :create]

  #before_action :set_author, only: [:show, :edit, :update, :destroy]

  # GET /authors
  # GET /authors.js
  # GET /authors.json
  def index
    authorize! :read, Author

    respond_to do |format|
      format.html
      format.js
      format.json { render json: AuthorsDatatable.new(view_context, @document) }
    end
  end

  # GET /authors/1
  # GET /authors/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /authors/new
  # GET /authors/new.js
  def new
    @author = @document.author.build
    authorize! :create, @author

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /authors/1/edit
  # GET /authors/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /authors
  # POST /authors.js
  def create
    @author = @document.authors.build(author_params)
    authorize! :create, @author

    respond_to do |format|
      if @author.save
        format.html { redirect_to @author, notice: "[#{@author.person}] was successfully created." }
        format.js   { redirect_to @author, notice: "[#{@author.person}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /authors/1
  # PATCH/PUT /authors/1.js
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to @author, notice: "[#{@author.person}]  was successfully updated." }
        format.js   { redirect_to @author, notice: "[#{@author.person}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.js
    def destroy
      the_name = @author.person
      @author.destroy
      respond_to do |format|
        format.html { redirect_to authors_url, notice: "[#{the_name}] was successfully deleted." }
        format.js   { redirect_to authors_url, notice: "[#{the_name}] was successfully deleted." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.

      def set_document
        @document = Document.find(params[:document_id])
      end

      def set_author
        @author = Author.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def author_params
        params.require(:author).permit(:person_id, :document_id, :main_author, :hidden, :order)
      end
end
