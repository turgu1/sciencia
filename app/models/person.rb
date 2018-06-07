class Person < ApplicationRecord

  belongs_to :organisation, inverse_of: :people
  belongs_to :user

  has_many :authors, inverse_of: :person, dependent: :destroy
  has_many :documents, through: :authors

  validates :first_name, :last_name, presence: true
  validates :organisation, presence: true

  counter_culture :organisation

  #default_scope { order('people.last_name,people.first_name ASC') }

  scope :like, ->(pattern = '') { where('TEXTCAT(last_name,first_name) ilike :pat', pat: "%#{pattern}%") }
  scope :alpha, -> { order('lower(last_name) ASC, lower(first_name) ASC') }
  scope :with_name, -> (last_name, first_name) { where(last_name: last_name, first_name: first_name) }
  scope :with_orgs, -> { includes(:organisation) }
  scope :with_docs, -> (id) {
    where(id: id).
    includes(:documents).
    order('documents.year ASC, documents.month ASC').
    references(:documents) }

  # When a person is *destroyed* from an organisation, it is automatically pushed in
  # the dedicated *Retrait* org. This is to insure that authors that left the
  # org are still shown in the document authors' list. This is so unless there is no
  # publication attached to the person as an author
  def destroy
    retired_org = Organisation.find_or_create_by(name: 'Retrait') do |org|
      org.abbreviation = 'Retrait'
    end

    if Author.where(person_id: self.id).count > 0
      self.organisation = retired_org
      self.save
    else
      super
    end
  end

  # Move a person to another organisation
  def move_to(org)
    self.organisation = org
    self.save
  end


  def mgr_ids
    self.organisation.mgr_ids
  end

  def is_author?(document_id)
    doc = Document.where(id: document_id).includes(:authors).take
    return false if doc.nil?
    doc.authors.each { |a| return true if (a.person_id == self.id) }
    false
  end

  # Replace person by another one, changing authorship
  # of associated documents to the other person. Person is
  # deleted after if required.
  def do_replace(target, delete_after)
    self.authors.each do |auth|
      if target.is_author?(auth.document_id)
        auth.destroy # Do not duplicate authorship
      else
        auth.person = target
        auth.save
      end
    end
    self.authors(true)
    self.destroy if delete_after

    return "Transformation completed. #{self.complete_name_with_org} replaced with #{target.complete_name_with_org}."
  end

  def complete_name
    [last_name, first_name].join(', ')
  end

  def caption
    complete_name_with_org
  end

  def short_name(output_type = :html)
    if first_name =~ /[A-Z]\.(\-?[A-Z]\.)?/ then  # First name in like initials
      str = [last_name, first_name].join(' ')
    else
      str = [last_name, initials(first_name).join('-').upcase].join(' ')
    end
    case output_type
      when :rtf
        (str.strip).gsub(' ', '\~').gsub('-', '\_')
      else
        str.strip
    end
  end

  def short_name_emphasize
    if first_name =~ /[A-Z]\.(\-?[A-Z]\.)?/ then  # First name in like initials
      [last_name.mb_chars.upcase, first_name].join(' ')
    else
      [last_name.mb_chars.upcase, initials(first_name).join('-').upcase].join(' ')
    end
  end

  def short_name_2
    if first_name =~ /[A-Z]\.(\-?[A-Z]\.)?/ then  # First name in like initials
      [last_name, first_name].join(' ')
    else
      [last_name, initials(first_name).join('').upcase].join(' ')
    end
  end

  def complete_name_with_org
    if self.organisation.nil? then
      self.complete_name
    else
      self.complete_name + ' (' + self.organisation.abbreviation + ')'
    end
  end

  def self.get_or_create(full_name, current_user)

    return nil if !(name = parse_name(full_name))

    abb = name[2]
    abb = 'Autre' if abb.blank?
    # puts "=====> Finding Org #{abb}"
    org = Organisation.find_or_create_by(abbreviation: abb) do |org|
      org.name = abb
      org.other = true
      org.order = 0
    end

    # puts "=====> Finding Person #{name[0]}, #{name[1]}"
    person = org.people.find_or_create_by(last_name: name[0], first_name: name[1]) do |p|
      p.user_id = current_user.id
      p.authors_count = 0
    end
  end

  def self.get(full_name)
    return nil if !(name = parse_name(full_name))
    return nil if name[2].blank?
    org = Organisation.where(abbreviation: name[2]).take
    return nil if org.nil?
    org.people.with_name(name[0], name[1]).take
  end

  # This method parses a complete name with org in parenthesis as an option. When a comma is present
  # the words preceding it are considered as the last name and the words after to be the first name.
  # When no comma is present, the first word is considered to be the first name and the rest to be
  # the last name.
  #
  # returns nil on wrong string entry
  #
  # The name string can take any of the following forms:
  #
  #  Turcotte, Guy (CME)
  #  Guy Turcotte (CME)
  #  Guy Turcotte

  def self.parse_name(name)

    return nil unless name.strip =~ /^([^(,]+)((,) *([^(,]*))? *(\((.*)\))? *$/

    the_name = [$1, $4, $6].map { |s| (s || '').strip }

    unless the_name[1].size > 0
      return nil unless the_name[0] =~ /^([^ ]+) +(.+)$/
      the_name[0] = $2
      the_name[1] = $1
    end

    the_name
  end

  private

    def initials(name)
      name.split('-').map { |x| x.mb_chars.first + '.' }
    end
end
