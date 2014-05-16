data = [
  service: 'amazon', settings: []
, service: 'amazon.com', settings: []
]

class Cassidy
  template: JST['application']

  constructor: ->
    @$fields = $('[type=password]')
    @$el     = $('<div>', class: 'cassidy-application')

    @bindEvents()

    # Auth with dropbox via options page
    # Store Phrase on options page
    # Find matching services for current domain
    # On click, create password, insert into field

    @attachElement()

  attachElement: ->
    @$el.html @template services: data

    @$fields.each (i, field) =>
      $field = $(field)
      offset = $field.offset()
      offset.top += $field.height() + 10

      @$el.css offset
      @$el.insertAfter $field

      @bindInputEvents $field

  populatePassword: (e) =>
    e.preventDefault()
    $field = @$el.prev('input')
    $field.val $.trim $(e.currentTarget).text()

  bindEvents: ->
    @$el.on 'click', (e) ->
      e.stopPropagation()

    @$el.on 'click', 'a', @populatePassword

    $(document).on 'click', =>
      @$el.hide()

  bindInputEvents: ($input) ->
    $input.on 'click', (e) =>
      e.stopPropagation()

    $input.on 'focus', (e) =>
      @$el.show()

$ ->
  new Cassidy
