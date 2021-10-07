document.addEventListener("turbolinks:load", function () {
  $("#stories").sortable({
    update: function (e, ui) {
      var AUTH_TOKEN = $("meta[name=csrf-token]").attr("content");

      $.ajaxPrefilter(function (options, originalOptions, xhr) {
        if (!options.crossDomain) {
          token = $('meta[name="csrf-token"]').attr("content");
          if (token) xhr.setRequestHeader("X-CSRF-Token", token);
        }
      });

      $.ajax({
        url: $(this).data("url") + "?&authenticity_token=" + AUTH_TOKEN,
        type: "PATCH",
        data: $(this).sortable("serialize"),
      });
    },
  });
});

document.addEventListener("input", (e) => {
  if (e.target.classList.contains("story-description")) {
    const desc = e.target;
    const form = desc.closest("form");
    const preview = form.querySelector(".story_preview .content");
    if (preview) {
      Rails.ajax({
        type: "POST",
        url: "/stories/render_markdown",
        data: `markdown=${encodeURIComponent(desc.value)}`,
        dataType: "text",
        success: (response) => {
          preview.innerHTML = response;
        },
      });
    }
  }
});
