class Dictionaries::SchoolsDatatable < Dictionaries::BaseDatatable

  def initialize(view)
    @model = Dictionaries::School
    super(view)
  end
end