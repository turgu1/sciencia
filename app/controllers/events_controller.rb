class EventsController < ApplicationController
  #before_action :set_event, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:index, :create]

  # GET /events
  # GET /events.js
  # GET /events.json
  def index
    authorize! :read, Event

    respond_to do |format|
      format.html
      format.js
      format.json { render json: EventsDatatable.new(view_context) }
    end
  end

  # GET /events/1
  # GET /events/1.js
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /events/new
  # GET /events/new.js
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /events/1/edit
  # GET /events/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /events
  # POST /events.js
  def create
    @event = Event.new(event_params)
    authorize! :create, @event

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "[#{@event.description}] was successfully created." }
        format.js   { redirect_to @event, notice: "[#{@event.description}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.js
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "[#{@event.description}]  was successfully updated." }
        format.js   { redirect_to @event, notice: "[#{@event.description}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.js
    def destroy
      the_name = @event.description
      @event.destroy
      respond_to do |format|
        format.html { redirect_to events_url, notice: "[#{the_name}] was successfully deleted." }
        format.js   { redirect_to events_url, notice: "[#{the_name}] was successfully deleted." }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_event
        @event = Event.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def event_params
        params.require(:event).permit(:description, :month, :year, :author_id, :document_id)
      end
end
