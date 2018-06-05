# Document ready methods to be executed after the document/form load process.
# Once validated that the document form is present it will:
# 1) adjust the authors' table classes to make it behave as a bootstrap table
# 2) insure zebra display for the authors' table
# 3) connect the arrows of all authors entries to allow key press on them
#    to move an authors in the requested direction
# 4) connect the document type selector to an ajax call to retrieve the list
#    of fields pertaining to the new document type
# 5) connect the addField, removeField buttons to the processs that will
#    ensure propre cleanup when the author list is being transformed
# 6) ensure that the right fields are displayed in the appropriate order, calling the
#    select_field_to show method

window.document_prep = () ->

  setup_typeahead()

  $('.check-duplicate').on('keyup', check_duplicate)

  $('#selection-toggle').off('change').on('change', (event) ->
    $('#select-check-box*:checkbox').prop('checked', (i, value) -> return !value)
  )

  if ($('#document-form').length != 0) && !$('#document-form').hasClass('initialized')
    $('#document-form').addClass('initialized')
    adjust_zebra('authors-table')
    adjust_zebra('events-table')

    $('a.up').on('click', move_up)
    $('a.down').on('click', move_down)

    select_fields_to_show()
    adjust_arrows('authors-table')

    $('#type-selector').on('change', (event) ->
      $.ajax(
        type:    'GET'
        url:     $(this).attr('change_path')
        data:    { document_type_id: $('#type-selector').val() }
        error:   (xhr, status) -> alert(status)
        success: () -> select_fields_to_show()
      ))

    $('#authors-table').on('cocoon:after-insert', (event, item) ->
      # $(document).on('nested:fieldAdded:authors', (event) ->
      setup_typeahead()
      # me = event.field.parents('table:first').find('tbody').children().last()
      me = item.parents('table:first').find('tbody').children().last()
      me.find('a.up').on('click', move_up)
      me.find('a.down').on('click', move_down)
      erase_empty_rows(me)
      adjust_order(me)
      adjust_arrows('authors-table')
      adjust_zebra('authors-table')
      adjust_focus(me)
      set_tooltip(me)
    )

    $('#authors-table').on('cocoon:after-remove', (event, item) ->
      # $(document).on('nested:fieldRemoved:authors', (event) ->
      # me = event.field
      me = $('#authors-table').find('tbody').children().first()
      adjust_order(me)
      adjust_arrows('authors-table')
      adjust_zebra('authors-table'))

    $('#events-table').on('cocoon:after-insert', (event, item) ->
      # me = event.field
      erase_empty_rows(item)
      adjust_zebra('events-table')
      setup_typeahead())

    $('#events-table').on('cocoon:after-remove', (event, item) ->
      # $(document).on('nested:fieldRemoved:events', (event) ->
      # me = event.field
      adjust_zebra('events-table'))

window.the_data = ''

window.build_selection_list = () ->
  liste = ''
  sep = ''
  $('#select-check-box*:checked').parents('tr').each((idx, elem) ->
    liste = liste + sep + $(elem).attr('id').replace('DOC_', '')
    sep = ','
  )
  #return liste
  $('input.selection-list').attr('value', liste)

window.setup_typeahead = () ->
  # Setup only the ones for which the typeahead() function has not been
  # call on (the parent section is not of class twitter-typeahead)
  $('input.typeahead').not($('.twitter-typeahead .typeahead')).each((v) ->
    path = $(this).attr('path')
    $(this).typeahead({
      # source can be a function
      items: 25
      minLength: 1
      source: (query, process) ->
        $.ajax({
          url:         path
          data:        { q: query }
          dataType:    'json'
          contentType: 'application/json; charset=utf-8'
          error:       (xhr, status) -> alert(status)
          success:     (data) -> window.the_data = data; process(data.captions)
        })
    }))

# This function insure that the right fields are displayed in the right order for the current document
# information. To do that it does the following
#
# 1) Hide all the fields present in the form
# 2) Retrieve the fields list located in the fields-to-show div in the document form
# 3) Take the field html data and put it in sequence at the end of the list, causing a reordering of the fields
#    in the appropriate order
# 4) Unhide the fields that are part of the list

select_fields_to_show = () ->
  $('#input-fields').children().hide()
  items = $.parseJSON($('.fields-to-show').html())
  $(items).each((i, field_name) -> $('#input-fields').append($('#' + field_name)))
  $(items).each((i, field_name) -> $('#' + field_name).show())

# As the authors list is being reordered using the up and down arrow, this function is being
# called to do some cleanup on the list and adjust the order numbering used to sort the authors list
# in the appropriate sequence. The following is done in sequence:
#
# 1) Get rid of the table entries were there is no data available. This is required as the
#    nested_form gem polluate the contain of the table with empty DIVs,
# 2) Select rows that are still valid (i.e. the ones that have not been destroyed by the user,
# 3) Sequence the order numbering of the fields list
# 4) Adjust the zebra coloring of the rows. As there is some rows that are hidden for destruction
#    purpose, the need to be bypassed. This is the main reason for atempting it here.
adjust_order = (row) ->
  row_list = $(row).parent('tbody').children().find('[name*="[_destroy]"][value="false"]')
  j = 1
  row_list.each((i,v) -> $(v).parents('tr:first').find('input[name*="[order]"]').attr('value', j++))

erase_empty_rows = (row) -> $(row).parent().children().remove('tr:empty')

adjust_zebra = (table_id) ->
  $('#' + table_id + ' tr').removeClass('alt');
  $('#' + table_id + ' tr:visible:even').addClass('alt');

adjust_arrows = (table_id) ->
  $('#' + table_id + ' tbody tr:visible a.up').show()
  $('#' + table_id + ' tbody tr:visible a.down').show()
  $('#' + table_id + ' tbody tr:visible:first a.up').hide()
  $('#' + table_id + ' tbody tr:visible:last a.down').hide()

adjust_focus = (row) -> $(row).find('.set_focus').focus()

set_tooltip  = (row) -> $(row).find('[data-toggle="tooltip"]').tooltip()

move_up = (event) ->
  me = $(this).parents("tr:first")
  me.insertBefore(me.prev())
  adjust_order(me)
  adjust_arrows('authors-table')
  adjust_zebra('authors-table')
  event.preventDefault()

move_down = (event) ->
  me = $(this).parents("tr:first")
  me.insertAfter(me.next())
  adjust_order(me)
  adjust_arrows('authors-table')
  adjust_zebra('authors-table')
  event.preventDefault()

# The following code is used to verify if the title of a document is a duplication
# of other documents. It does an Ajax call to the server that will populate a warning msg
# below the title if there is any title duplicates in the database.
# The document id, if it exists, is also transmitted to insure that the current document
# will not be considered a duplicate.

check_duplicate_timer = 0
target = undefined

do_check_duplicate = () ->
  title = $(target).val()
  url   = $(target).data('url')
  call_remote_with_param(url, { title: title }) if title.length > 5

window.check_duplicate = (event) ->
  clearTimeout check_duplicate_timer
  target = event.target
  check_duplicate_timer = setTimeout(do_check_duplicate, 700)
