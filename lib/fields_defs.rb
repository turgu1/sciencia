# encoding: utf-8

module FieldsDefs
    
  def FieldsDefs.a_ff(name, label, edit, show)
    { name => { label: label, edit: edit, show: show }}
  end

  def FieldsDefs.a_collection(name, id, order_field)
    "collection_select(:document, :#{id}_id, #{name}.find(:all, order: \'\"#{order_field}\" ASC\'), :id, :caption)"
  end

  def FieldsDefs.a_collection_full(name, id, order_field)
    "if ('#{id.to_s}' == 'document_sub_category') and (document.document_type.abbreviation == 'SL') then " +
      "collection_select(:document, :#{id}_id, #{name}.find(:all, order: \'\"#{order_field}\" ASC\', conditions: [\'sl = ?\', true]), :id, :full_caption) " +
    "else " +
      "collection_select(:document, :#{id}_id, #{name}.find(:all, order: \'\"#{order_field}\" ASC\'), :id, :full_caption) " +
    "end"
  end

  # text field
  def FieldsDefs.a_tf(field_name)
    "form.text_field(:#{field_name}, size: 50, id: 'field-#{field_name}')+sciencia_drop_target('field-#{field_name}')"
  end

  # auto_complete field
  def FieldsDefs.a_ac(name)
    "text_field_with_auto_complete(:document, :#{name}_caption, { size: 50 }, { url: #{name}s_path(:js), method: :get, param_name: 'search' })+sciencia_drop_target('document_#{name}_caption')"
  end

  def FieldsDefs.a_fn(field_name)
    "document.#{field_name}"
  end

  def FieldsDefs.a_fni(field_name)
    "document.#{field_name}.to_s"
  end

  def FieldsDefs.a_caption(name)
    "document.#{name.to_s.downcase}.caption"
  end

  def FieldsDefs.a_simple_ff(name, label = '')
    a_ff(name, label, a_tf(name), a_fn(name.to_s))
  end

  def FieldsDefs.an_area_ff(name, label = '')
    a_ff(name, label, "form.text_area(:#{name}, rows: 6, id: 'field-#{name}')+sciencia_drop_target('field-#{name}')", "document.#{name}")
  end

  def FieldsDefs.a_collection_ff(name, id, order_field, label = '')
    a_ff(id, label, a_collection(name, id, order_field), a_caption(id))
  end

  def FieldsDefs.a_collection_full_ff(name, id, order_field, label = '')
    a_ff(id, label, a_collection_full(name, id, order_field), a_caption(id))
  end

  def FieldsDefs.an_integer_ff(name, label = '')
    a_ff(name, label, a_tf(name), a_fni(name.to_s))
  end

  def FieldsDefs.an_auto_complete_ff(name, label = '')
    a_ff(name, label, a_ac(name), a_caption(name))
  end
end
