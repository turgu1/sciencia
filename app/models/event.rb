class Event < ApplicationRecord

  belongs_to :author, inverse_of: :events
  belongs_to :document, inverse_of: :events

  validates :description, :month, :year, :author_id, presence: true

  def date
    sprintf "%04d.%02d", self.year, self.month
  end

  def author_name
    author.try(:name) || ''
  end

end
