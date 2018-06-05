class OrganisationsController < ApplicationController
  #before_action :set_organisation, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: [:index, :create, :replace_with]

  # GET /organisations/1/replace.js
  def replace
    authorize! :manage, @organisation

    @old         = @organisation
    @return_path = organisations_path
    @exec_path   = replace_with_organisations_path
  end

  # POST /organisations/replace_with.js
  def replace_with
    pars = replacement_params
    organisation = Organisation.find(pars[:old_id])
    authorize! :manage, organisation

    new_organisation = Organisation.where(abbreviation: pars[:new_org]).take
    authorize! :manage, new_organisation

    if organisation.nil? || new_organisation.nil?
      flash[:error] = "Cannot be completed as requested. The #{organisation.nil? ? 'targeted' : 'origin'} organisation does not exists."
    else
      flash[:notice] = organisation.do_replace(new_organisation, pars[:delete_after] == '1')
    end

    redirect_to organisations_path
  end

  # GET /organisations
  # GET /organisations.json
  def index
    authorize! :read, Organisation

    if params[:q]
      @items = Organisation.like(params[:q]).alpha
      respond_to do |format|
        format.json   {
          @data = { captions: @items.map { |org| org.abbreviation } }
          render json: @data
        }
      end
    else
      respond_to do |format|
        format.html
        format.js
        format.json { render json: OrganisationsDatatable.new(view_context) }
      end
    end
  end

  # GET /organisations/1
  # GET /organisations/1.json
  def show
    if params[:modal]
      render action: :show_modal
    else
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  # GET /organisations/new
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /organisations/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /organisations
  # POST /organisations.json
  def create
    @organisation = Organisation.new(organisation_params)
    authorize! :create, @organisation

    respond_to do |format|
      if @organisation.save
        format.html { redirect_to @organisation, notice: 'Organisation was successfully created.' }
        format.js   { redirect_to @organisation, notice: 'Organisation was successfully created.' }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /organisations/1
  # PATCH/PUT /organisations/1.json
  def update
    respond_to do |format|
      if @organisation.update(organisation_params)
        format.html { redirect_to @organisation, notice: 'Organisation was successfully updated.' }
        format.js   { redirect_to @organisation, notice: 'Organisation was successfully updated.' }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.json
  def destroy
    @organisation.destroy
    flash[:notice] = "Organisation #{@organisation.abbreviation} was successfully deleted."
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organisation
      @organisation = Organisation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organisation_params
      params.require(:organisation).permit(:name, :abbreviation, :people_count, :other, :order)
    end

    def replacement_params
      params.require(:replacement).permit(:old_id, :new_org, :delete_after)
    end
end
