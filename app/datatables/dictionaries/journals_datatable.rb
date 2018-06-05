class Dictionaries::JournalsDatatable < Dictionaries::BaseDatatable

  def initialize(view)
    @model = Dictionaries::Journal
    super(view)
  end
end