class Dictionaries::InstitutionsDatatable < Dictionaries::BaseDatatable

  def initialize(view)
    @model = Dictionaries::Institution
    super(view)
  end
end