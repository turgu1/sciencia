class PeopleController < ApplicationController
  before_action :set_organisation, only: [:index, :new, :create, :move, :do_move, :replace_with]

  load_and_authorize_resource only: [:show, :edit, :update, :destroy]

  def move
    @person = Person.where(id: params[:id]).includes(:organisation).take
    authorize! :manage, @person

    respond_to do |format|
      format.js
    end
  end

  def do_move
    person = Person.where(id: move_params[:person_id]).includes(:organisation).take
    authorize! :manage, person

    old_org = person.organisation
    target_org = Organisation.get_or_create(move_params[:target_org_abbreviation])
    person.move_to(target_org)

    flash[:notice] = "[#{person.complete_name}] has been moved to #{person.organisation.name}."

    respond_to do |format|
      format.html  { redirect_to organisation_path(old_org) }
      format.js { redirect_to organisation_path(old_org) }
    end
  end

  # GET /people/1/replace.js
  def replace
    @person = Person.where(id: params[:id]).includes(:organisation).take
    authorize! :manage, @person

    @old         = @person
    @return_path = organisation_path(@person.organisation_id)
    @exec_path   = replace_with_organisation_people_path(@person.organisation_id)
  end

  # POST /people/replace_with.js
  def replace_with
    pars = replacement_params
    person = Person.find(pars[:old_id])
    authorize! :manage, person

    org_id = person.organisation_id

    target_person = Person.get(pars[:target_person])
    authorize! :manage, target_person

    if person.nil? || target_person.nil?
      flash[:error] = "Cannot be completed as requested. The #{person.nil? ? 'targeted' : 'origin'} individual does not exists."
    else
      flash[:notice] = person.do_replace(target_person, pars[:delete_after] == '1')
    end

    redirect_to organisation_path(org_id)
  end

  # This is called to present the modal dialog for documents selection and, once
  # the dialog parameters are set, to prepare and send back the document list in
  # the selected output format (html, xml, rtf, bibtex)
  #
  # As an example, suppose the user selected the Word Document (rtf) format, the
  # following methods/partials will be called in sequence:
  #
  # people_controller#publication_list : with params[:the_format] set to 'rtf'
  #   -> people/publication_list_params.js.erb : Show modal dialog for documents selection
  #      -> people_controller#publication_list : Return here with modal-params set
  #         -> publication_list.rtf.haml : list preparation in the rtf format

  def publication_list
    authorize! :read, Person

    mparams = params[:modal_params]

    if mparams and (mparams[:from_month] or mparams[:all_publications])
      # Process the request
      # Here, we retrieve the selected documents for the person, as requested by
      # the user through the modal dialog.
      @person = Person.with_docs(params[:id]).take

      # logger.debug "====== @person.inspect ====="
      # logger.debug @person.inspect
      # logger.debug @person.authors.inspect
      # logger.debug @person.documents.inspect

      @document_structure = DocumentCategory.docs_for_list(@person) unless @person.documents.size == 0

      # logger.debug "====== @document_structure.inspect ====="
      # logger.debug @document_structure.inspect

      @locals = { person:  @person,
                  selection_params:  {
                    from_month:  ((mparams[:all_publications] == '0') ? mparams[:from_month].to_i : 0),
                    from_year:  ((mparams[:all_publications] == '0') ? mparams[:from_year].to_i : 0),
                    from_selection:  mparams[:from_selection] == '1',
                    selection:  mparams[:selection].split(',').map { |s| s.to_i },
                    all:  mparams[:all_publications] == '1' } }

      # logger.debug "====== @local.inspect ====="
      # logger.debug @locals.inspect
      # logger.debug "====== end ====="

      respond_to do |format|
        format.html
        format.js
        format.xml {
          send_data(
              @person.documents.select { |d| document_selected?(d, @locals[:selection_params]) }.to_xml(
                  except: [:id, :document_type_id, :document_sub_category_id, :peer_review_id,
                           :security_classification_id,
                           :journal_id, :publisher_id, :institution_id, :org_id, :language_id,
                           :editor_id, :school_id, :last_update_by_id],
                  include: [
                      { authors: { except: [:id, :person_id, :document_id],
                                   include: [ { person: { except: [:id, :organisation_id, :user_id, :authors_count],
                                                          include: [ { organisation: { only: [:name, :abbreviation] } } ]
                                   } } ]
                      } },
                      { events: { except: [:id, :author_id, :document_id],
                                  include: [ { author: { except: [:id, :person_id, :document_id],
                                                         include: [ { person: { except: [:id, :organisation_id, :user_id, :authors_count],
                                                                                include: [ { organisation: { only: [:name, :abbreviation] } } ]
                                                         } } ]
                                  } } ]
                      } },
                      { document_type:           { only: [:caption, :abbreviation] } },
                      { document_sub_category:   { only: [:caption, :abbreviation] } },
                      { peer_review:             { only: [:caption, :abbreviation] } },
                      { security_classification: { only: [:caption, :abbreviation] } },
                      { journal:     {only: [:caption] } },
                      { publisher:   {only: [:caption] } },
                      { institution: {only: [:caption] } },
                      { org:         {only: [:caption] } },
                      { language:    {only: [:caption] } },
                      { editor:      {only: [:caption] } },
                      { school:      {only: [:caption] } }
                  ]
              ),
              filename: 'publication_list.xml',
              type: :xml)
        }
        format.rtf
        format.bib
      end
    else
      # Ask for parameters through the publication_list_params.js.erb partial
      fmt = params[:the_format] == 'html' ? :html : params[:the_format].to_sym
      @target = publication_list_person_path(params[:id], format:  fmt)
      @format = { html:  'WEB(HTML)', rtf:  'WORD', bib:  'BibTeX', xml:  'XML' }[params[:the_format].to_sym] || 'ERROR!!!'
      respond_to do |format|
        format.js { render action:  :publication_list_params }
      end
    end
  end

  # GET /people
  # GET /people.js
  # GET /people.json
  # GET /people.json?q=abc
  def index
    authorize! :read, Person

    if params[:q]
      @items = Person.like(params[:q]).alpha.with_orgs
      respond_to do |format|
        format.json   {
          @data = { captions: @items.map { |p| p.complete_name_with_org } }
          render json: @data
        }
      end
    else
      respond_to do |format|
        format.html
        format.js
        format.json { render json: PeopleDatatable.new(view_context, @organisation) }
      end
    end

  end

  # GET /people/1
  # GET /people/1.js
  def show
    if params[:modal]
      render action: :show_modal
    elsif params[:doc_modal]
      render action: :documents_modal
    else
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  # GET /people/new
  # GET /people/new.js
  def new
    @person = @organisation.people.build
    authorize! :create, @person
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /people/1/edit
  # GET /people/1/edit.js
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /people
  # POST /people.js
  def create
    @person = @organisation.people.build(person_params)
    authorize! :create, @person

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: "[#{@person.complete_name}] was successfully created." }
        format.js   { redirect_to @person, notice: "[#{@person.complete_name}]  was successfully created." }
      else
        format.html { render action: 'new' }
        format.js   { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.js
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: "[#{@person.complete_name}]  was successfully updated." }
        format.js   { redirect_to @person, notice: "[#{@person.complete_name}]  was successfully updated." }
      else
        format.html { render action: 'edit' }
        format.js   { render action: 'edit' }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.js
  def destroy
    @the_name = @person.complete_name
    @the_id = @person.id
    @organisation = @person.organisation
    @person.destroy
    if Person.where(id: @the_id).count > 0
      the_notice = "[#{@the_name}] was moved to 'Retrait' (Still used as an author)."
    else
      the_notice = "[#{@the_name}] was successfully deleted."
    end
    flash[:notice] = the_notice
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organisation
      @organisation = Organisation.find(params[:organisation_id]) if params[:organisation_id]
    end
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :email, :phone, :organisation_id)
    end

    def move_params
      params.require(:move).permit(:person_id, :target_org_abbreviation)
    end

    def replacement_params
      params.require(:replacement).permit(:old_id, :target_person, :delete_after)
    end
end
