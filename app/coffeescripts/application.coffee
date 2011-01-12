app =
  init: ->
    app.show_messages()
    
  show_messages: ->
    $("#messages").slideDown('slow').fadeTo(3000, 1).slideUp('slow');

$(document).ready app.init

jQuery(document).bind "ready", () ->
    $('select#locale').selectmenu({
        icons: [
            {find: '.english-us'},
            {find: '.french-france'},
            {find: '.hebrew-israel'}
        ],
        width: 42,
        menuWidth: 200,
        style: 'dropdown',
        change: (ev,ui) ->
            switch ui.value
                when 0 then window.location = "/en"
                when 1 then window.location = "/fr"
                when 2 then window.location = "/he"
    })

