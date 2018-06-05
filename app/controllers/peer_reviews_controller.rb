class PeerReviewsController < ApplicationController
  #before_action :set_peer_review, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:index, :create]

  # GET /peer_reviews
  # GET /peer_reviews.js
  # GET /peer_reviews.json
  def index
    authorize! :read, PeerReview

    respond_to do |format|
      format.html
      format.js
      format.json { render json: PeerReviewsDatatable.new(view_context) }
    end
  end

  # GET /peer_reviews/1
  # GET /peer_reviews/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /peer_reviews/new
  # GET /peer_reviews/new.js
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /peer_reviews/1/edit
  # GET /peer_reviews/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /peer_reviews
  # POST /peer_reviews.js
  def create
    @peer_review = PeerReview.new(peer_review_params)
    authorize! :create, @peer_review

    respond_to do |format|
      if @peer_review.save
        format.html { redirect_to @peer_review, notice: "[#{@peer_review.caption}] was successfully created." }
        format.js   { redirect_to @peer_review, notice: "[#{@peer_review.caption}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /peer_reviews/1
  # PATCH/PUT /peer_reviews/1.js
  def update
    respond_to do |format|
      if @peer_review.update(peer_review_params)
        format.html { redirect_to @peer_review, notice: "[#{@peer_review.caption}]  was successfully updated." }
        format.js   { redirect_to @peer_review, notice: "[#{@peer_review.caption}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /peer_reviews/1
  # DELETE /peer_reviews/1.js
    def destroy
      the_name = @peer_review.caption
      @peer_review.destroy
      respond_to do |format|
        format.html { redirect_to peer_reviews_url, notice: "[#{the_name}] was successfully deleted." }
        format.js   { redirect_to peer_reviews_url, notice: "[#{the_name}] was successfully deleted." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_peer_review
        @peer_review = PeerReview.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def peer_review_params
        params.require(:peer_review).permit(:caption, :abbreviation, :order)
      end
end
