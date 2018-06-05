# Used to detect initial (useless) popstate.
# If history.state exists, assume browser isn't going to fire initial popstate.
#popped = ('state' in window.History)
#initialURL = location.href

# This function is called at page load time
$ ->
  $(document).ajaxStart(() -> $('body').addClass('busy'))
  $(document).ajaxStop(()  -> $('body').removeClass('busy'))

  on_ajax_load()
#  $(window).bind("popstate", (event) ->
#
#    # Ignore inital popstate that some browsers fire on page load
#    initialPop = !popped && location.href == initialURL
#    popped = true
#    return if initialPop
#
#    event.preventDefault()
#    $.getScript(location.href)
#    return false
#  )

  # Processing inside nested_forms when an entry is added. Adjust the fields
  # according to their kind
  #  $(document).on('nested:fieldAdded', (event) -> on_field_added(event))

#  History = window.History # Note: We are using a capital H instead of a lower h
#  if (History.enabled)
#    State = History.getState();
#    # set initial state to first page that was loaded
#    History.pushState({urlPath: window.location.pathname}, $("title").text(), State.urlPath);
#  else
#    # History.js is disabled for this browser.
#    # This is because we can optionally choose to support HTML4 browsers or not.
#    return false

# This function is called both at page load time and after ajax calls.
window.on_ajax_load = () ->

  # Initialize date picker prefered date format
  $('.datepicker').datepicker({ format: 'yyyy-mm-dd' })

  # Adjust tables to be presented as condensed and striped. The no-strip class prevent a
  # table to be striped...
  # $('table')        .addClass('table table-condensed').not('.no-strip').addClass('table-striped')
  $('table').not('.plain')
    .addClass('table table-condensed')
    .not('.manual-zebra')
      .not('.no-strip').addClass('table-striped')
      .not('.no-border').addClass('table-bordered')
  $('.dtable').not('.dataTable').each((index, elem) ->
    options = {}
    unless $(elem).data('sort-column') == undefined
      options = {
        aaSorting: [[$(elem).data('sort-column'), $(elem).data('sort-order')]]
      }
    $(elem).dataTable($.extend(true, {}, options, {
      sDom:            "<'row'<'col-md-6'r><'col-md-6'f>>t<'row'<'col-md-6'i><'col-md-6'>>"
      bAutoWidth:      false
      bProcessing:     true
      bServerSide:     true
      bRetrieve:       true
      bScrollCollapse: true
      iDisplayLength:  1000
      sAjaxSource:     $(elem).data('source')
      aoColumnDefs: [
        { bSortable: false,           aTargets: ['no-sort']  }
        { sClass: 'no-wrap',          aTargets: ['no-wrap']  }
        { sClass: 'no-wrap no-print', aTargets: ['buttons']  }
        { sClass: 'hcenter',          aTargets: ['hcenter']  }
        { sClass: 'hleft',            aTargets: ['hleft']    }
        { sClass: 'hright',           aTargets: ['hright']   }
        { sClass: 'hcenter no-wrap',  aTargets: ['datetime'] }
      ]
      fnServerData: ( sSource, aoData, fnCallback, oSettings ) ->
        oSettings.jqXHR = call_remote(sSource, {
          dataType: 'json',
          type:     'GET',
          data:     aoData,
          success:  fnCallback })
    }))
  )

  # Insure that links wont be printed
  $('a').addClass('no-print')

  # $('.tip').tooltip()
  $('[data-toggle="tooltip"]').tooltip();
  
  # An easy way to tag buttons to be shown with as small ones with the blue backgroune
  $('.smallbtn')    .addClass('btn btn-primary btn-sm smalll')
  $('.xsmallbtn')   .addClass('btn btn-primary btn-xs smalll')

  # An easy way to tag input fields as Bootstrap form-control
  $('form').addClass('form-horizontal')
  $('form input').not('.btn').not('.file').not('[type="checkbox"]').not('[type="radio"]').addClass('form-control')
  $('form select')  .addClass('form-control')
  $('form textarea').addClass('form-control')

  $('.form-actions').addClass('col-md-offset-3')

  $('label.checkbox').addClass('checkbox-inline')

  # Adjusts all pills labels to reflect the presence or not of selected equipments.
  $('#equipment_selection').each(() -> adjust_all_pill_labels($(this)))

  # An easy way to identify a focused field at load time
  $('.focus').focus()

  # For nested forms, associate an event to adjust new fields loaded
  # $('.nested-container').on('cocoon:after-insert', () -> on_ajax_load())

  document_prep() # Looks at documents.js.coffee

  $('textarea.comment').not('wysi').each((i, elem) -> $(elem).addClass('wysi').wysihtml5());

$(document).ajaxComplete((event, requirement) ->
#  flash = requirement.getResponseHeader('X-Flash-Messages');
#  if (!flash)
#    $('#flash-pane').html('')
#  else
#    $('#flash-pane').html(flash)
  on_ajax_load())

# Called by returning code from the server to append a new object to a selected list of
# data
window.append_content = (selector, with_content, select_new_pane = false) ->
  $(selector).append(with_content);

# Called by returning code from the server to replace the html content of an DOM object
# identified using a jquery selector
window.replace_content = (selector, with_content, select_new_pane = false) ->
  $(selector).html(with_content)
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next a').attr('href')
      if url &&  $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text('Fetching more documents...')
        $.getScript(url)
    $(window).scroll()

# Called by returning code from the server to replace the value attribute of an DOM object with
# the prepared payload coming from the server. The selector is a jquery valid selector.
window.replace_value = (selector, with_content) ->
  $(selector).attr('value', with_content)

# Ajax call with a complete url
# Options can be a string or an object with parameters
window.call_remote = (url, options = { type: 'GET' }) ->
#  alert('sSource = ' + url)

  if typeof options == 'string'
    options = { type: options }
  if options.type == undefined
    $.extend(options, { type: 'GET' })
  if options.dataType == undefined
    $.extend(options, { dataType: 'script' })
  pushIt = options.push == true
  delete options.push;

  res = $.ajax($.extend({
    url: url
    cache: false
  }, options))

#  if pushIt
#    History.pushState(null, '', url)

  res

# Ajax call with a single dynamic parameter
window.call_remote_with_param = (url, params) ->
  $.ajax({
    type: 'GET',
    url: url,
    data: params,
    cache: false,
    dataType: 'script'
  # success: (data) -> eval(data)
  })

# This is used to hide a modal dialog when an associated button is pressed
window.hide_modal = (event) ->
  event.preventDefault()
  $('#modal-dialog').modal('hide')
