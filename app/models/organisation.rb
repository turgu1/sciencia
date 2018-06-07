class Organisation < ApplicationRecord
  has_many :people, inverse_of: :organisation, dependent: :destroy
  #has_and_belongs_to_many :users  STRANGE???

  validates :name, :abbreviation, :order, presence: true
  validates :name, :abbreviation, uniqueness: true
  validates :order, numericality:  { only_integer: true, greater_than_or_equal_to: 0 }

  scope :others,  -> { where(other: true) }
  scope :main,    -> { where(other: false) }
  scope :like,    -> (pattern = '') { where('name ilike :pat or abbreviation ilike :pat', pat: "%#{pattern}%") }
  scope :sidebar, -> (other_org = false) {
    includes(:people).
    order('organisations."order" ASC, organisations.abbreviation ASC, people.last_name ASC, people.first_name ASC').where('other = ?', other_org).
    references(:organisations, :people)
   }
  scope :ordered, -> { order('"order" ASC', 'abbreviation ASC') }
  scope :alpha,   -> { order('lower(abbreviation) ASC') }

  def full_caption
    self.abbreviation + ' - ' + self.name
  end

  def caption
    self.name
  end

  def self.get_or_create(abbrev)
    find_or_create_by(abbreviation: abbrev) do |org|
      org.name = abbrev
      org.other = true
    end
  end

  def do_replace(new_org, delete_after)
    #self.people.each do |p|
    #  p.organisation = new_org
    #  p.save
    #end
    # The following maybe more efficient then above
    new_org.people << self.people
    new_org.save
    msg = "[#{self.name}] replaced with [#{new_org.name}]"
    if delete_after
      self.destroy
      msg << ' and deleted.'
    end
    return msg
  end
end
