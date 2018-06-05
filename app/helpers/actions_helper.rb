module ActionsHelper

  # These are all the methods used for displaying action buttons everywhere in the
  # application

  def download_action(entry, options = {})
    my_options = options.dup
    classes = (my_options[:class] || '') + ' btn btn-xs btn-primary'
    my_options[:class] = classes.strip

    link_to(
        'Download',
        url_for(:controller => entry.class.name.pluralize.underscore,
                :action => :download,
                :id => entry.id),
        my_options
    ) if can? :read, entry
  end

  def move_action(entry, options = {})
    my_options = options.dup
    classes = (my_options[:class] || '') + ' btn btn-xs btn-warning'
    my_options[:class] = classes.strip

    remote_link_to(
        'Move',
        url_for(:controller => entry.class.name.pluralize.underscore,
                :action => :move,
                :id => entry.id),
        my_options
    ) if can? :manage, entry
  end

  def replace_action(entry, options = {})
    my_options = options.dup
    classes = (my_options[:class] || '') + ' btn btn-xs btn-warning'
    my_options[:class] = classes.strip

    remote_link_to(
        'Replace',
        url_for(:controller => entry.class.name.pluralize.underscore,
                :action => :replace,
                :id => entry.id),
        my_options
    ) if can? :manage, entry
  end

  def show_action(entry, options = {}, path_options = {})
    my_options = options.dup
    classes = (my_options[:class] || '') + ' btn btn-xs btn-info'
    my_options[:class] = classes.strip
    remote_link_to(
        'Show',
        url_for({
            controller: entry.class.name.pluralize.underscore,
            action: 'show',
            only_path: true,
            id: entry.id
        }.merge(path_options)),
        my_options
    ) if can? :read, entry
  end

  def new_action(entry, options = {}, path_options = {})
    my_options = options.dup
    classes = (my_options[:class] || '') + ' btn btn-xs btn-primary'
    my_options[:class] = classes.strip
    if entry.is_a?(Array)
      p = "new_#{entry.map{|e|e.class.name.underscore}.join('_')}_path"
      path = self.send(p, *entry[0..-2])
    else
      path = url_for({
               controller: entry.name.pluralize.underscore,
               action: :new
           }.merge(path_options))
    end
    remote_link_to('New', path, my_options) if can? :create, entry.is_a?(Array) ? entry[-1] : entry
  end

  def edit_action(entry, options = {}, path_options = {})
    my_options = options.dup
    classes = (my_options[:class] || '') + ' btn btn-xs btn-primary'
    my_options[:class] = classes.strip
    path = url_for({
             controller: entry.class.name.pluralize.underscore,
             action: 'edit',
             only_path: true,
             id: entry.id
         }.merge(path_options))
    remote_link_to('Edit', path, my_options) if can? :update, entry
  end

  def delete_action(entry, label, options = {}, path_options = {})
    my_options = options.dup
    classes = (my_options[:class] || '') + ' btn btn-xs btn-danger'
    my_options[:class]   ||= classes.strip
    my_options[:method]  ||= :delete
    my_options[:data]      = { confirm: "Deleting [#{label}] ... \rAre you sure?" }
    my_options[:remote]  ||= true
    path = url_for({
             controller: entry.class.name.pluralize.underscore,
             action: 'destroy',
             only_path: true,
             id: entry.id
         }.merge(path_options))
    link_to('Destroy', path, my_options) if can? :destroy, entry
  end

  def all_actions(entry, label, options = {}, path_options = {})
    "#{show_action(entry, options, path_options)} #{edit_action(entry, options, path_options)} #{delete_action(entry, label, options, path_options)}".html_safe
  end

end