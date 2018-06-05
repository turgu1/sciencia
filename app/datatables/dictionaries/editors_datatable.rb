class Dictionaries::EditorsDatatable < Dictionaries::BaseDatatable

  def initialize(view)
    @model = Dictionaries::Editor
    super(view)
  end
end