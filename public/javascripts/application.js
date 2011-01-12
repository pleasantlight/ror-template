/* DO NOT MODIFY. This file was compiled Tue, 11 Jan 2011 17:48:03 GMT from
 * /home/noam/Dropbox/PleasantLight/dev/ruby/ror-template/app/coffeescripts/application.coffee
 */

(function() {
  var app;
  app = {
    init: function() {
      return app.show_messages();
    },
    show_messages: function() {
      return $("#messages").slideDown('slow').fadeTo(3000, 1).slideUp('slow');
    }
  };
  $(document).ready(app.init);
  jQuery(document).bind("ready", function() {
    return $('select#locale').selectmenu({
      icons: [
        {
          find: '.english-us'
        }, {
          find: '.french-france'
        }, {
          find: '.hebrew-israel'
        }
      ],
      width: 42,
      menuWidth: 200,
      style: 'dropdown',
      change: function(ev, ui) {
        switch (ui.value) {
          case 0:
            return window.location = "/en";
          case 1:
            return window.location = "/fr";
          case 2:
            return window.location = "/he";
        }
      }
    });
  });
}).call(this);
