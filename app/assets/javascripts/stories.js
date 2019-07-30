document.addEventListener("turbolinks:load", function() {
  $("#stories").sortable({
    update: function(e, ui) {
      var AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');

      $.ajaxPrefilter(function(options, originalOptions, xhr) {
        if (!options.crossDomain) {
          token = $('meta[name="csrf-token"]').attr('content');
          if (token) xhr.setRequestHeader('X-CSRF-Token', token);
        }
      });

      $.ajax({
        url: $(this).data("url") + "?&authenticity_token=" + AUTH_TOKEN,
        type: "PATCH",
        data: $(this).sortable('serialize'),
      });
    }
  });
});
