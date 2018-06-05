class Dictionaries::LanguagesDatatable < Dictionaries::BaseDatatable

  def initialize(view)
    @model = Dictionaries::Language
    super(view)
  end
end