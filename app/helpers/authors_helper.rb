module AuthorsHelper

  def some_error_in_authors(list)
    return true unless list.errors.messages[:authors].nil?

    list.each do |l|
      return true if l.errors.messages
    end


  end
end
