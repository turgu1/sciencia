class Dictionaries::PublishersDatatable < Dictionaries::BaseDatatable

  def initialize(view)
    @model = Dictionaries::Publisher
    super(view)
  end
end