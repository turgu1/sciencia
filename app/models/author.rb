class Author < ApplicationRecord

  belongs_to :person, inverse_of: :authors
  belongs_to :document, inverse_of: :authors

  has_many :events, dependent:  :destroy, inverse_of: :author

  validates_inclusion_of :main_author, in: [true, false]
  validate :check_name

  counter_culture :person

  default_scope { includes(:person).order('"order" ASC') }

  accepts_nested_attributes_for :person, allow_destroy:  false

  before_save :adjust_person

  #validates_associated :document, :person

  # Pseudo attribute, to simplify the management of new persons, as the name
  # is required to create the proper entry as a Person, if it doesn't exists.
  def name=(value)
    @name = value
  end

  def name
    @name ||= (person.complete_name_with_org unless person.nil?)
  end

  private

    def check_name
      unless self.name.blank?
        if Person.parse_name(self.name).nil?
          errors.add(:name, "Must be «Last-name, First-name (ORG)» or «First-name Last-name (ORG)»")
          errors.add(:name, "«(ORG)» is optional.")
        end
      end
    end

    def adjust_person
      if self.name.blank?
        self.person_id = nil
      else
        p = Person.get(self.name)
        self.person_id = p.try(:id)
      end
    end
end
