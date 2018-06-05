class Document < ApplicationRecord

  belongs_to :document_sub_category,   inverse_of: :documents
  belongs_to :document_type,           inverse_of: :documents
  belongs_to :security_classification, inverse_of: :documents
  belongs_to :peer_review,             inverse_of: :documents

  belongs_to :editor,      class_name: 'Dictionaries::Editor',      foreign_key: 'editor_id',      inverse_of: :documents
  belongs_to :institution, class_name: 'Dictionaries::Institution', foreign_key: 'institution_id', inverse_of: :documents
  belongs_to :org,         class_name: 'Dictionaries::Org',         foreign_key: 'org_id',         inverse_of: :documents
  belongs_to :publisher,   class_name: 'Dictionaries::Publisher',   foreign_key: 'publisher_id',   inverse_of: :documents
  belongs_to :school,      class_name: 'Dictionaries::School',      foreign_key: 'school_id',      inverse_of: :documents
  belongs_to :language,    class_name: 'Dictionaries::Language',    foreign_key: 'language_id',    inverse_of: :documents
  belongs_to :journal,     class_name: 'Dictionaries::Journal',     foreign_key: 'journal_id',     inverse_of: :documents

  belongs_to :user, foreign_key: :last_update_by_id

  has_many :authors,     inverse_of: :document, dependent: :destroy, autosave: true
  has_many :attachments, inverse_of: :document, dependent: :destroy
  has_many :events,      inverse_of: :document, dependent: :destroy, autosave: true

  has_many :people,      through: :authors

  accepts_nested_attributes_for :authors,
                                allow_destroy: true,
                                reject_if: proc { |author| author['name'].blank? }

  accepts_nested_attributes_for :events,
                                allow_destroy: true,
                                reject_if: proc { |event| (event['description'].blank? or event['author_id'].nil?) }

  accepts_nested_attributes_for :attachments,
                                allow_destroy: true,
                                reject_if: proc { |event| (event['doc_file'].blank?) }

  validates :title, :security_classification_id, :peer_review_id, :document_type_id, :document_sub_category_id,
            :month, :year, presence: true

  validates :document_reference, uniqueness: true, allow_blank: true
  validates_associated :authors

  validate :at_least_one_main
  validate :user_present

  validates :title,
    format: { with: /(.+)(\((U|PA)\))/,
              message: "Le titre doit posséder un marqueur de classification [ (U) ou (PA) ] à la fin du libellé." },
    if: -> (d) { d.security_classification.title_marker }

  scope :like, -> (pattern = '') { where('TEXTCAT(title,document_reference) ilike :pat', pat: "%#{pattern}%") }
  scope :all_references, -> { includes([
      :security_classification, :peer_review, :editor, :institution, :journal,
      :language, :org, :publisher, :school,
      { events: { author: :person } }
    ]) }

  #default_scope { includes([:document_type, :document_sub_category]).order('documents.year ASC, documents.month ASC') }

  # Return the list of fields that are to be included in forms. Of that list, the events, attachments and document_type
  # are absent as they are treated separately

  BIBTEX_TYPE_TRANSLATION = {
      "TM" => 'techreport',
      "TR" => 'techreport',
      "TN" => 'techreport',
      "SL" => 'article',
      "LR" => 'techreport',
      "OTH" => 'misc',
      "BR" => 'patent',
      "CR" => 'techreport',
      "ECR" => 'techreport'
  }

  BIBTEX_SUBTYPE = {
      "TM" => 'Technical Memorandum',
      "TR" => 'Technical Report',
      "TN" => 'Technical Note',
      "SL" => 'Article',
      "LR" => 'Letter Report',
      "OTH" => 'Others',
      "BR" => 'Patent',
      "CR" => 'Contract Report',
      "ECR" => 'E. Contract Report'
  }

  def self.fields
    [
        :title, :address, :booktitle, :howpublished, :location, :lccn, :url, :copyright,
        :keywords, :chapter, :edition, :key, :number, :series, :volume, :isbn, :issn,
        :page_count, :pages_reference, :document_reference, :annote, :note, :abstract,
        :contents, :editor, :institution, :journal, :language, :org, :publisher, :school,
        :security_classification, :peer_review, :document_sub_category, :authors, :month,
        :year
    ]
  end

  def author_ids
    self.authors.collect(&:person_id)
  end

  def bibtex_type
    a = BIBTEX_TYPE_TRANSLATION[self.document_type.abbreviation]
    a || 'unknown'
  end

  def date
    sprintf "%04d.%02d", self.year, self.month
  end

  %w(journal institution editor org publisher school language).each do |tbl|

    eval %Q{
      def #{tbl}_caption
        #{tbl}.caption if #{tbl}
      end

      def #{tbl}_caption=(caption)
        self.#{tbl} = do_caption(Dictionaries::#{tbl.camelize}, caption)
      end
    }
  end

  def is_author?(user)
    return nil if user.person.nil?
    !author_ids.index(user.person.id).nil?
  end

  # Return an array of events for which +person+ is an author.
  def events_for(person)
    self.events.select { |event| event.author.person_id == person.id unless event.author.nil? }
  end

  # Replace a dictionary table pointer with another entry from the same table.
  # It is used by the "replace_with" method of dictionary controllers.
  def self.do_replace(klass, old_id, new_id, remove_old)
    new_rec = nil
    old_rec = klass.find(old_id)
    new_rec = klass.find(new_id) unless new_id.blank?

    the_new_id = new_rec.try(:id) || nil
    field_name = "#{klass.table_name.singularize.underscore}_id"

    if old_rec.nil?
      "Transformation not completed. #{klass.name} id not found: #{old_id}."
    else
      docs = Document.where("#{field_name} = ?", old_rec.id)
      docs.each do |doc|
        doc.send "#{field_name}=", the_new_id
        doc.save
      end
      if remove_old
        old_rec.destroy
        msg2 = " #{old_rec.caption} deleted."
      else
        msg2 = ''
      end
      "Transformation completed. [#{old_rec.caption}] replaced with [#{new_rec ? new_rec.caption : 'None'}].#{msg2}"
    end
  end

  # Constitue la liste des auteurs d'un document pour l'affichage ou la préparation des rapports. Est
  # utilisé partout où il est nécessaire de présenter les auteurs sous forme de liste. Permet de présenter
  # les auteurs principaux de manière soulignée ou en majuscules, dépendamment du paramètre *output_type*.
  def author_list(output_type = :html)
    if authors.empty?
      'None'
    else
      liste = authors.sort { |a, b| a.order <=> b.order }.collect do |author|
        unless author.hidden?
          if author.main_author?
            case output_type
              when :html
                "<nobr>#{author.person.short_name(output_type).mb_chars.upcase}</nobr>"
              when :rtf
                "{#{author.person.short_name(output_type).mb_chars.upcase}}"
              when :bibtex
                author.person.complete_name
              else
                author.person.short_name_emphasize
            end
          else
            if output_type == :html
              "<nobr>#{author.person.short_name(output_type)}</nobr>"
            else
              author.person.short_name(output_type)
            end
          end
        end
      end
      liste.compact.join((output_type == :bibtex) ? ' and ' : ', ').html_safe
    end
  end

  def adjustments_before_save(current_user)

    self.last_update_by_id = current_user.id
    self.peer_review_id ||= 1
    prepare_authors(current_user)
    adjust_sub_category
    check_for_CR_type(current_user)
    sequence_authors_order
    ensure_events_are_connected_to_authors

  end

  # The use of a class attribute could become an issue if more than one user start a bibtex output at the
  # same time. Not sure how rails manage object caches between users...
  def self.init_bibtex_ident
    @@bibtex_idents = {}
  end

  def bibtex_ident

    def base_ident
      ident = ((authors.select { |a| a.main_author? }.try(:first).try(:person).try(:last_name)) || 'Unknown') + (self.year || '2013').to_s
      ident.gsub(' ', '')
    end

    @@bibtex_idents ||= {}

    bident = base_ident
    @@bibtex_idents[bident] = 0 if (idx = @@bibtex_idents[bident]).nil?
    idx ||= 0

    res = bident + 'abcdefghijklmnopqrstuvwxyz'[idx % 26]

    @@bibtex_idents[bident] = idx+1

    return res

  end

  private

    # Ensure that:
    #   - Entries without an author name are marked for destruction
    #   - The person associated with the author exists in the database
    #   - All authors are unique
    def prepare_authors(current_user)
      return if self.authors.nil?
      person_ids = []

      self.authors.each do |author|
        unless author.marked_for_destruction?
          if author.name.strip.blank?
            author.mark_for_destruction
          else
            be_sure_author_exists(author, current_user) # as a person, add him if he does not exists.
            author.mark_for_destruction if person_ids.index(author.person.id)
            person_ids << author.person.id
          end
        end
      end
    end

    def adjust_sub_category
      unless self.document_type.abbreviation == 'SL'
        unless self.peer_review.nil?
          if self.peer_review_id == 1
            self.document_sub_category = self.document_type.no_peer_review_document_sub_category
          else
            self.document_sub_category = self.document_type.peer_review_document_sub_category
          end
        else
          self.document_sub_category = self.document_type.no_peer_review_document_sub_category
        end
      end
    end

    def check_for_CR_type(current_user)
      # S'il n'y a pas d'auteur caché et que l'utilisateur n'est pas un auteur, on
      # l'ajoute comme auteur caché...
      def add_user_as_hidden_author(current_user)
        return if current_user.role?(:dba)
        self.authors.each do |auth|
          unless auth.marked_for_destruction?
            return if auth.person_id == current_user.person_id
            return if auth.hidden # Nécessaire lorsque le pilote ajuste une entrée pour un autre utilisateur
          end
        end
        au = Author.new({
              main_author: true,
              hidden:      true,
              person:      current_user.person,
              name:        current_user.person.complete_name_with_org,
              order:       100
          })
        self.authors << au
      end

      def remove_hidden_authors
        self.authors.each do |auth|
          if auth.hidden? then
            auth.mark_for_destruction
          end
        end
      end

      if self.document_type.hidden_author
        add_user_as_hidden_author(current_user)
      else
        remove_hidden_authors
      end
    end

    def sequence_authors_order
      unless self.authors.blank?
        self.authors.select { |a|
          (not (a.marked_for_destruction? or a.hidden))
        }.sort { |a,b|
          (a.order || 999) <=> (b.order || 999)
        }.each_with_index { |a, i|
          a.order = i + 1
        }

        self.authors.select { |a|
          ((not a.marked_for_destruction?) and a.hidden)
        }.sort { |a,b|
          (a.order || 999) <=> (b.order || 999)
        }.each_with_index { |a, i|
          a.order = i + 100
        }
      end
    end

    def ensure_events_are_connected_to_authors
      unless self.events.blank?
        auths = self.authors.map { |auth| auth.id unless auth.marked_for_destruction? }.compact
        self.events.each do |event|
          event.mark_for_destruction if auths.index(event.author_id).nil?
        end
      end
    end

    # Verify if the author exists as a person in the database. If not, it is created...
    def be_sure_author_exists(author, current_user)
      person = nil
      person = Person.find(author.person_id) unless author.person_id.nil?
      person = Person.get_or_create(author.name, current_user) if person.nil?
      author.person = person
      author.name = person.complete_name_with_org
      # logger.debug "========> Author's person: #{author.person.inspect} id: #{author.person_id}."
    end

    def at_least_one_main
      found = false
      count = 0
      authors.each do |auth|
        unless auth.marked_for_destruction?
          if auth.main_author?
            found = true
          end
          count = count + 1
        end
      end
      unless found
        errors.add(:authors, "At least one author must be set as a main author.")
      end
      if count == 0
        errors.add(:authors, "Authors cannot be empty.")
      end
    end

    def user_present
      user = User.find(self.last_update_by_id)
      return if user.role?(:admin) || user.role?(:pilot) || user.role?(:dba)
      some_error = user.nil? || user.person_id.nil?
      unless some_error
        user_found = false
        authors.each do |auth|
          unless auth.marked_for_destruction?
            #puts "=======> auth.person = #{auth.person.try(:complete_name_with_org) || 'Unknown!'}"
            user_found ||= (auth.person_id == user.person_id)
          end
        end
        some_error ||= !user_found
      end
      errors.add(
        :authors,
        "User (#{user.try(:username) || 'Unknown!!'} => #{user.try(:person).try(:complete_name_with_org) || 'Unknown!!'}) must be present as an author!") if some_error
    end

    def do_caption(klass, caption)
      caption.blank? ? nil : klass.find_or_create_by(caption: caption)
    end

end
