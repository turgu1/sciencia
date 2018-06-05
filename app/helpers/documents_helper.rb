# encoding: utf-8

require 'fields_defs'

module DocumentsHelper

  include FieldsDefs

  def field_input_html(form, field_name)
    case field_name
      when :title
        form.input field_name, input_html: {
          class: ['check-duplicate'],
            data: { url: check_duplicate_documents_path(doc_id: (form.object.id ? form.object.id : nil)) }}
      when :address, :booktitle, :howpublished
        form.input field_name
      when :location, :lccn, :url, :copyright, :keywords
        form.input field_name
      when :chapter, :edition, :key, :number, :series, :volume, :isbn, :issn, :page_count, :pages_reference
        form.input field_name, input_html: {class: 'small-field'}
      when :annote, :note, :abstract, :contents
        form.input field_name, as: :text
      when :document_reference
        form.input field_name
      when :editor, :institution, :journal, :language, :org, :publisher, :school
        form.input(
          "#{field_name}_caption",
          label: "<i class='fa fa-magic'></i>&nbsp;&nbsp;#{field_name}".html_safe,
          input_html: {
              class: 'typeahead col-md-8',
              path: url_for(
                  controller: "dictionaries/#{field_name.to_s.pluralize}",
                  action: :index,
                  format: :json
              )})
      when :language
        form.association field_name, label_method: :caption, include_blank: true
      when :last_update_by
        form.input field_name, as: :hidden
      when :security_classification
        form.association :security_classification,
                         label_method: :caption,
                         include_blank: false,
                         collection: SecurityClassification.select_order
      when :peer_review
        form.association :peer_review, label_method: :caption, include_blank: false,
                         collection: PeerReview.select_order
      when :document_sub_category
        # Only time it uses is for document_type == Scientific Literature
        form.association :document_sub_category,
                         collection: DocumentSubCategory.sl_sub,
                         label_method: :caption,
                         include_blank: false,
                         input_html: { class: 'large-field' }
      when :authors
        render partial: 'documents/authors_table', object: form
      when :month
        form.input :month,
                   collection: months_collection,
                   include_blank: false,
                   label_method: :first,
                   value_method: :last
      when :year
        form.input :year,
                   collection: years_collection,
                   input_html: {class: 'small-field'},
                   include_blank: false
      else
        "<p>UNKNOWN FIELD: #{field_name}</p>"
    end
  end

  def form_input_fields(form, fields_sym)
    the_fields = []
    typ = DocumentType.find(doc_type_id)
    unless typ.nil?
      typ.fields_sym_list.each do |field_name|
        the_fields << field_input_html(form, field_name)
      end
    end
    return the_fields
  end

  def self.no_break(str, output_type)
    case output_type
      when :html
        "<nobr>#{str}</nobr>"
      when :rtf
        str.strip.gsub(' ', '\~')
      else
        str.strip
    end
  end

  FieldFormats = Hash[ *[
      FieldsDefs.a_simple_ff(:title, 'Title*'),
      FieldsDefs.a_simple_ff(:address),
      FieldsDefs.a_simple_ff(:booktitle, 'Book Title'),
      FieldsDefs.a_simple_ff(:chapter),
      FieldsDefs.a_simple_ff(:edition),
      FieldsDefs.a_simple_ff(:howpublished, 'How Published'),
      FieldsDefs.a_simple_ff(:key),
      FieldsDefs.a_simple_ff(:series),
      FieldsDefs.a_simple_ff(:copyright),
      FieldsDefs.a_simple_ff(:isbn, 'ISBN'),
      FieldsDefs.a_simple_ff(:issn, 'ISSN'),
      FieldsDefs.a_simple_ff(:keywords),
      FieldsDefs.a_simple_ff(:location),
      FieldsDefs.a_simple_ff(:lccn, 'LCCN'),
      FieldsDefs.a_simple_ff(:url,  'URL'),
      FieldsDefs.a_simple_ff(:page_count),
      FieldsDefs.a_simple_ff(:pages_reference),

      FieldsDefs.an_area_ff(:annote),
      FieldsDefs.an_area_ff(:note),
      FieldsDefs.an_area_ff(:abstract),
      FieldsDefs.an_area_ff(:contents),

      FieldsDefs.an_auto_complete_ff(:journal),
      FieldsDefs.an_auto_complete_ff(:editor),
      FieldsDefs.an_auto_complete_ff(:institution),
      FieldsDefs.an_auto_complete_ff(:org),
      FieldsDefs.an_auto_complete_ff(:school),
      FieldsDefs.an_auto_complete_ff(:language),

      #FieldsDefs.a_collection_ff('Journal',                 :journal_id,              'caption', 'Journal'),
      #FieldsDefs.a_collection_ff('SecurityClassification',   :security_classification, 'order',   'Security Clasification*'),
      FieldsDefs.a_collection_ff('PeerReview',               :peer_review,             'order',   'Peer Review*'),
      #FieldsDefs.a_collection_ff('DocumentCategory',        :document_category,       'order',   'Document Category'),
      FieldsDefs.a_collection_full_ff('DocumentSubCategory', :document_sub_category,   'order',   'Document Sub Category*'),
      #FieldsDefs.a_collection_ff('Editor',                  :editor,                  'caption', 'Editor'),
      #FieldsDefs.a_collection_ff('Institution',             :institution,             'caption', 'Institution'),
      FieldsDefs.a_collection_ff('DocumentType',             :document_type,           'order',   'Document Type*'),
      #FieldsDefs.a_collection_ff('Org',                     :org,                     'caption', 'Organisation'),
      #FieldsDefs.a_collection_ff('Publisher',               :publisher,               'caption', 'Publisher'),
      #FieldsDefs.a_collection_ff('School',                  :school,                  'caption', 'School'),
      #FieldsDefs.a_collection_ff('Language',                :language,                'caption', 'Language'),

      FieldsDefs.a_ff(
          :number,
          'Number',
          FieldsDefs.a_tf(:number),
          lambda { |document, output_type|
            no_break('issue ' + document.number.to_s, output_type) unless document.number.blank?
          }
      ),

      FieldsDefs.a_ff(
          :security_classification,
          'Security Classification',
          FieldsDefs.a_ac(:security_classification),
          lambda { |document, output_type|
            if (!document.security_classification.blank?) && document.security_classification.title_marker
              document.security_classification.caption
            end
          }

      ),

      FieldsDefs.a_ff(
          :volume,
          'Volume',
          FieldsDefs.a_tf(:volume),
          lambda { |document, output_type|
            no_break('volume ' + document.volume.to_s, output_type) unless document.number.blank?
          }
      ),

      FieldsDefs.a_ff(
          :publisher,
          'Publisher',
          FieldsDefs.a_ac(:publisher),
          lambda { |document, output_type|
            unless document.publisher.blank? || document.publisher.is_a_reference_prefix?
              document.publisher.caption
            end
          }
      ),

      FieldsDefs.a_ff(
          :document_reference,
          'Document Reference',
          FieldsDefs.a_tf(:document_reference),
          lambda { |document, output_type|
            str1 = ''
            unless document.publisher.nil?
              if document.publisher.is_a_reference_prefix?
                str1 = (document.publisher.reference_prefix.blank? ?
                    document.publisher.caption :
                    document.publisher.reference_prefix) + ' '
              end
            end
            str2 = ''
            unless document.document_reference.blank?
              str2 = no_break(document.document_reference, output_type)
            end
            str1 + str2
          }
      ),

      FieldsDefs.a_ff(
          :month, 'Month*', "select_month(document.month, {}, {:name => 'document[month]'})",
          lambda { |document, output_type|
            case output_type
              when :bibtex
                %w[jan feb mar apr may jun jul aug sep oct nov dec][document.month-1]
              else
                %w[janvier février mars avril mai juin juillet août septembre octobre novembre décembre][document.month-1]
            end
            }),
      FieldsDefs.a_ff(
          :date, 'Date', nil,
          lambda { |document, output_type|
            case output_type
              when :bibtex
                "#{%w[jan feb mar apr may jun jul aug sep oct nov dec][document.month-1]} #{document.year.to_s}"
              else
                "#{%w[janvier février mars avril mai juin juillet août septembre octobre novembre décembre][document.month-1]} #{document.year.to_s}"
            end
            }),
      FieldsDefs.a_ff(
          :year,  'Year*', "select_year(document.year, { :start_year => 1970, :end_year => (Time.now.year + 2) }, { :name => 'document[year]' })", "document.year.to_s"),
      FieldsDefs.a_ff(
          :authors, 'Authors*', "render :partial => 'authors_block', :object => document", 'author_list(document, output_type)'),
      FieldsDefs.a_ff(
          :title, 'Title*', FieldsDefs.a_tf(:title),
          # Traitement spécial du titre lorsque celui-ci se termine avec un niveau
          # de classification de sécurité entre parenthèses: Le blanc précedant
          # la parenthèse gauche est remplacé par un blanc insécable, afin qu'un
          # saut de ligne ne vienne séparer la cote de sécurité de la fin du titre.
          lambda { |document, output_type|
            if document.title =~ /^(.+)(\(.+\))$/
              a = $1.strip
              b = $2.strip
            else
              a = document.title
              b = ''
            end
            case output_type
              when :html
                b = '&nbsp;' + b unless b.blank?
                b = '&nbsp;(U)' if ((document.security_classification.title_marker) and b.blank?)
                "#{a + b}"
              when :rtf
                b = '\~' + b unless b.blank?
                b = '\~(U)' if ((document.security_classification.title_marker) and b.blank?)
                res = "{#{a + b}}"
                # puts "=====> #{res.encode('cp1252')}"
                res
              else
                document.title
            end
          })
  ].collect { |h| h.to_a }.flatten ]

  # Constitue la liste des auteurs d'un document pour l'affichage ou la préparation des rapports. Est
  # utilisé partout où il est nécessaire de présenter les auteurs sous forme de liste. Permet de présenter
  # les auteurs principaux de manière soulignée ou en majuscules, dépendamment du paramètre *output_type*.
  def author_list(document, output_type = :html)
    if document.authors.empty?
      'None'
    else
      liste = document.authors.sort { |a, b| a.order <=> b.order }.collect do |author|
        unless author.hidden?
          if author.main_author?
            case output_type
              when :html
                "<nobr>#{remote_link_to h(author.person.short_name(output_type).mb_chars.upcase), person_path(author.person, doc_modal: true)}</nobr>"
              when :html2
                "<nobr>#{h(author.person.short_name(output_type).mb_chars.upcase)}</nobr>"
              when :rtf
                "{#{author.person.short_name(output_type).mb_chars.upcase}}"
              when :bibtex
                h author.person.complete_name.mb_chars.upcase
              else
                h author.person.short_name_emphasize.mb_chars.upcase
            end
          else
            case output_type
              when :html
                "<nobr>#{remote_link_to h(author.person.short_name(output_type)), person_path(author.person, doc_modal: true)}</nobr>"
              when :html2
                "<nobr>#{h(author.person.short_name(output_type))}</nobr>"
              else
                h author.person.short_name(output_type)
            end
          end
        end
      end
      liste.compact.join((output_type == :bibtex) ? ' and ' : ', ')
    end
  end

  def available_fields_list
    FieldFormats.keys.collect {|key| key.to_s}.sort
  end

  def is_the_user?(person_id)
    (not person_id.nil?) and
        (person_id > 0) and
        (person_id == current_user.person_id)
  end

  def is_the_user_a_main_author?(document)
    document.authors.each do |author|
      return true if is_the_user?(author.person_id) and author.main_author?
    end
    false
  end

  def do_label (document, form, field_name)
    if FieldFormats[field_name][:label].size == 0 then
      form.label field_name
    else
      form.label field_name, FieldFormats[field_name][:label]
    end
  end

  def do_edit_field(document, form, field_name)
    eval(FieldFormats[field_name][:edit])
  end

  def do_label_text (document, field_name)
    if FieldFormats[field_name][:label].size == 0
      field_name.to_s.humanize + ':'
    else
      FieldFormats[field_name][:label] + ':'
    end
  end

  def do_field_text(document, field_name, blank_value, output_type = :html)
    if eval("document.#{field_name}.blank?")
      res = blank_value
    else
      if FieldFormats[field_name][:show].class == Proc
        res = FieldFormats[field_name][:show].call(document, output_type)
      else
        res = eval(FieldFormats[field_name][:show])
      end
      if res.blank?
        res = blank_value
      end
    end
    res
  end

  def gen_input_fields(document, form, field_names_string)
    def gen_input_field(document, form, field_name)
      if field_name == :all
        stream = FieldFormats.collect { |key, _| gen_input_field(document, form,  key) }
        stream.join
      else
        if FieldFormats[field_name]
          "<p>" + do_label(document, form, field_name) + do_edit_field(document, form, field_name) + "</p>"
        else
          "<p>Field not found!! :#{field_name}</p>"
        end
      end
    end

    unless field_names_string.nil?
      stream = field_names_string.split.collect do |field_name|
        gen_input_field(document, form, eval(field_name))
      end
      stream.join
    end
  end

  # A partir d'une liste de champs sous la forme d'une chaîne de caractères,
  # représentés chacun par un symbole, crée un vecteur contenant,
  # pour chaque entrée, un vecteur de deux valeurs contenant un libelle et la valeur
  # correspondante au champ en provenance de l'objet document
  def gen_show_fields(document, field_names_string)

    # A partir d'un nom de champ et d'on objet document, génère
    # un vecteur contenant deux entrées: Un premier champ donnant le
    # libelle et un second champ contenant la valeur du champ dans
    # l'objet document. Utilisé principalement pour l'affichage
    # de l'action "document/show"
    def gen_show_field(document, field_name)
      if FieldFormats[field_name] then
        [ do_label_text(document, field_name), do_field_text(document, field_name, "&nbsp;") ]
      else
        [ "Field not found!!:", "#{field_name}" ]
      end
    end

    unless field_names_string.nil? then
      if field_names_string == "all" then
        FieldFormats.collect { |key, _| gen_show_field(document, key) }
      else
        field_names_string.split.map do |field_name|
          gen_show_field(document, eval(field_name))
        end
      end
    end
  end

  # A partir d'une liste de champs sous la forme d'une chaîne de caractères,
  # représentés chacun par un symbole, crée un vecteur contenant,
  # pour chaque entrée, la valeur
  # correspondante au champ en provenance de l'objet document, formatté selon le
  # type de sortie voulu:  :html, :rtf ou :bibtex
  def gen_report_data_for_document(document, field_names_string, output_type = :html)

    def gen_field_report(document, field_name, output_type = :html)
      if field_name == :all
        stream = FieldFormats.collect { |key, _| gen_show_field(document, key) }
        stream.delete_if { |a| a.blank? }.join(', ')
      else
        if FieldFormats[field_name]
          do_field_text(document, field_name, "", output_type)
        else
          case output_type
            when :html
              "<p>Field not found!! :#{field_name}</p>"
            when :rtf
              "{\b Field not found!! :#{field_name}}"
            else
              "Field not found!! :#{field_name}"
          end
        end
      end
    end

    def is_a_number?(s)
      s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

    def escape_dquote(s)
      begin
        old = s
        s = s.sub('"', '``')
        s = s.sub('"', "''")
      end while old != s
      return s
    end

    def escape_text(s)
      s = escape_dquote(s)

      s.gsub!('{', '\{')
      s.gsub!('}', '\}')
      s.gsub!('$', '\$')
      s.gsub!('ç', '\c{c}')
      s.gsub!('Ç', '\c{C}')
      s.gsub!('à', '\\\\`{a}')
      s.gsub!('À', '\\\\`{A}')
      s.gsub!('è', '\\\\`{e}')
      s.gsub!('È', '\\\\`{E}')
      s.gsub!('ì', '\\\\`{i}')
      s.gsub!('Ì', '\\\\`{I}')
      s.gsub!('ò', '\\\\`{o}')
      s.gsub!('Ò', '\\\\`{O}')
      s.gsub!('ù', '\\\\`{u}')
      s.gsub!('Ù', '\\\\`{U}')
      s.gsub!('é', "\\\\'{e}")
      s.gsub!('É', "\\\\'{E}")
      s.gsub!('â', '\^{a}')
      s.gsub!('Â', '\^{A}')
      s.gsub!('ê', '\^{e}')
      s.gsub!('Ê', '\^{E}')
      s.gsub!('î', '\^{i}')
      s.gsub!('Î', '\^{I}')
      s.gsub!('ô', '\^{o}')
      s.gsub!('Ô', '\^{O}')
      s.gsub!('û', '\^{u}')
      s.gsub!('Û', '\^{U}')
      s.gsub!('ä', '\"{a}')
      s.gsub!('Ä', '\"{A}')
      s.gsub!('ë', '\"{e}')
      s.gsub!('Ë', '\"{E}')
      s.gsub!('ï', '\"{i}')
      s.gsub!('Ï', '\"{I}')
      s.gsub!('ö', '\"{o}')
      s.gsub!('Ö', '\"{O}')
      s.gsub!('ü', '\"{u}')
      s.gsub!('Ü', '\"{U}')
      s.gsub!('ÿ', '\"{y}')
      s.gsub!('Ÿ', '\"{Y}')
      s.gsub!('ñ', '\~{n}')
      s.gsub!('Ñ', '\~{N}')

      return s
    end

    unless field_names_string.nil?
      if output_type == :bibtex
        stream = field_names_string.split.collect do |field_name|
          the_field = eval(field_name)
          aa = gen_field_report(document, the_field, output_type)
          if aa.blank? then
            nil
          else
            if is_a_number?(aa) || (the_field == :month)
              value = aa.to_s
            else
              value = escape_text(aa)
              if the_field == :title
                value = "{#{value}}" # We then get double braces {{ ... }}
              end
              value = "{#{value}}"
            end

            the_field = {
                authors:     :author,
                title:       :title,
                page_count:  :note,
                year:        :year,
                month:       :month,
                editor:      :editor,
                institution: :institution,
                publisher:   :publisher,
                journal:     :journal,
                school:      :school,
                org:         :organization,
                url:         :url,
                type:        :type
            }[the_field]

            if the_field.nil?
              nil
            else
              "  #{the_field.to_s} = #{value}"
            end
          end
        end
        stream.delete_if { |a| a.blank? }.join(",\n")
      else
        stream = field_names_string.split.collect do |field_name|
          gen_field_report(document, eval(field_name), output_type)
        end
        res = stream.delete_if { |a| a.blank? }.join(', ') + '.'
        puts("======> #{res.encode('cp1252')}")
        res
      end
    end
  end

  # Translate a string from its UTF-8 representation to the CP1252 format. Mainly use
  # in the production of RTF Format.
  def to_cp1252(str)
    str.encode('cp1252')
  end

  # Prepare the list of events for output in the publication list. +events+ contains
  # the Event object list for the document to be formatted. +formatted_events+
  # produces
  # a list of strings ready for inclusion in the publication list. The entries
  # are concatenated considering a similar description. For example, the following
  # entries:
  #
  #         Other one                             March     1997
  #         Presentation at DRDC Valcartier       January   2009
  #         Presentation at DRDC Valcartier       December  2001
  #
  # will produce:
  #
  #         Other one (Mars 1997)
  #         Presentation at DRDC Valcartier (Janvier 2009, Décembre 2001)
  #
  def formatted_events(events, fmt = :html)
    case fmt
      when :rtf
        bl = '\~'
      when :html
        bl = '&nbsp;'
      else
        bl = 'OUPS!!!'
    end
    evf = []
    return evf if events.empty?
    current = ''
    str = ''
    events.each do |ev|
      if current != ev.description
        current = ev.description
        unless str.blank?
          str << ')'
          evf << str
        end
        str = ev.description + ' ('
      else
        str << ', '
      end
      str << (%w[Janvier Février Mars Avril Mai Juin Juillet Août Septembre Octobre Novembre Décembre ][ev.month - 1])
      str << bl
      str << ev.year.to_s
    end
    unless str.blank?
      str << ')'
      evf << str
    end
    evf
  end

  def document_selected?(d, selection_params)
    # puts("--> #{all}(#{all.class.name}, #{from_selection}, #{fyear}, #{fmonth}, #{selection}")
    return true if selection_params[:all]
    if selection_params[:from_selection]
      return !selection_params[:selection].index(d.id).nil?
    else
      return ((d.year > selection_params[:from_year]) || ((d.year == selection_params[:from_year]) && (d.month >= selection_params[:from_month])))
    end
  end

  def some_document_in_sub_category?(sub_category, selection_params)
    return true if (selection_params[:all] && !sub_category.documents.blank?)
    doc = sub_category.documents.each do |doc|
      return true if document_selected?(doc, selection_params)
    end
    return false
  end

  def some_document_in_category?(category, selection_params)
    category.document_sub_categories.each do |sub_cat|
      return true if some_document_in_sub_category?(sub_cat, selection_params)
    end
    false
  end

  def some_document?(list, selection_params)
    # logger.info "===================="
    # logger.info list.inspect
    # logger.info "===================="
    list.each do |cat|
      return true if some_document_in_category?(cat, selection_params)
    end
    return false
  end

  def doc_to_text(document)
    gen_report_data_for_document(document, document.document_type.report_field_list, :txt)
  end
end
