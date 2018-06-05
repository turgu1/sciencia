class Dictionaries::OrgsDatatable < Dictionaries::BaseDatatable

  def initialize(view)
    @model = Dictionaries::Org
    super(view)
  end
end