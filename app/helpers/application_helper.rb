module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-danger alert-warning">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  # Predefined associated field names -> path to the value to be displayed
  FIELD_VALUES = {
      security_classification:              { security_classification: :full_caption },
      peer_review:                          { peer_review: :full_caption },
      document_type:                        { document_type: :caption },
      editor:                               { editor: :caption },
      institution:                          { institution: :caption },
      org:                                  { org: :caption },
      publisher:                            { publisher: :caption },
      school:                               { school: :caption },
      language:                             { language: :caption },
      journal:                              { journal: :caption },
      document_category:                    { document_category: :caption },
      document_sub_category:                { document_sub_category: :full_caption },
      last_update_by:                       { last_update_by: :username },
      organisation:                         { organisation: :name },
      authors:                              :author_list,
      author:                               { author: { person: :short_name } },
      document:                             { document: :document_reference },
      peer_review_document_sub_category:    { peer_review_document_sub_category: :full_caption },
      no_peer_review_document_sub_category: { no_peer_review_document_sub_category: :full_caption },
      user:                                 { user: :username },
      translation:                          { translation: :caption }
  }

  class Bldr
    def initialize(params)
      @context_obj = params[:target]
    end

    def field(field_name, label = nil)
      the_name   = field_name.class == Hash ? field_name : (FIELD_VALUES[field_name] || field_name)
      label    ||= (field_name.class == Hash ? field_name.first[0] : field_name).to_s.humanize
      val        = @context_obj

      while the_name.class == Hash
        val = val.send(the_name.first[0]) unless val.nil?
        the_name = the_name.first[1]
      end

      val = val.send(the_name) unless val.nil?
      val = '&nbsp;' if val.blank?
      val = val.getlocal.strftime('%F %T') if val.is_a?(Time)

      "<dt>#{label.to_s}</dt><dd>#{val.to_s}</dd>".html_safe
    end
  end

  def show_entry(obj, &block)
    context = Bldr.new(:target => obj)
    ("<dl class='dl-horizontal'>" + capture(context, &block) + "</dl>").html_safe
  end

  def show_error(obj, field)
    (content_tag(:span, obj.errors.messages[field].join(','), class: 'help-inline') unless obj.errors.messages[field].size == 0) || ''
  end

  def remote_link_to label, href, options = {}
    my_options = options.dup
    my_options[:push] ||= true
    opt = my_options[:push] == true ? ',{push: true}' : ''
    my_options.delete(:push)
    my_options[:onclick] ||= "call_remote('#{href}'#{opt})"
    my_options[:style] ||= 'cursor:pointer;'
    my_options[:href] ||= '#'
    content_tag(:a, label, my_options)
  end

  def months_collection
    t("date.month_names")[1..12].each_with_index.map { |v,i| [v, i+1] }
  end

  def years_collection
    (Date.today.year-15)..(Date.today.year+3)
  end

end
