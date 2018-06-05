module DocumentTypesHelper
  def doc_type_list(document_type)
    "[ " + document_type.fields_sym_list.map { |s| "\"field-#{s.to_s}\"" }.join(',') + " ]"
  end
end
