document.addEventListener("turbolinks:load", function () {
  $("#stories, .sortable-projects").sortable({
    update: function (e, ui) {
      Rails.ajax({
        type: "PATCH",
        url: this.dataset.url,
        data: $(this).sortable("serialize"),
      });
    },
  });
});
